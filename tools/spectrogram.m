%% Copyright (C) 2000 Paul Kienzle
%%
%% This program is free software and may be used for any purpose.  This
%% copyright notice must be maintained. Paul Kienzle is not responsible
%% for the consequences of using this software.

%% usage: [S, f, t] = spectrogram(x, Fs, window, step, maxF, shape, minE)
%%
%% Generate a spectrogram for the signal. This chops the signal into
%% overlapping slices, windows each slice and applies a Fourier
%% transform to determine the frequency components at that slice.
%%
%% x:      signal to analyse
%% Fs:     sampling rate for the signal
%% window: analysis window length (default 30 msec)
%% step:   time between windows, start to start (default 5 ms)
%% maxF:   maximum frequency to display (default 4000 Hz)
%%    Alternatively, use [maxF, nF], where nF is the minimum
%%    of frequency points to display.  If nF is greater than
%%    what it would normally be for the given window size and
%%    maximum displayed frequency, the FFT is zero-padded until
%%    it at least nF points are displayed on the y axis.
%% shape:  window analysis function (default 'hanning')
%%    Shape is any function which takes an integer n and returns
%%    a vector of length n.  If shape contains %d and ends with
%%    ')', as for example '(1:%d)' or 'kaiser(%d,0.5)' do, then
%%    %d is replaced with the desired window length, and the
%%    expression is evaluated.
%% minE:   noise floor (default -40dB)
%%    Any value less than the noise floor is clipped before the
%%    spectrogram is displayed.  This limits the dynamic range
%%    that your spectrogram must accomodate.  Alternatively,
%%    use [minE, maxE], where maxE is the clipping ceiling, also
%%    in decibels.
%%
%% Return values
%%    S is the spectrogram in S with linear magnitude normalized to 1.
%%    f is the frequency indices corresponding to the rows of S.
%%    t is the time indices corresponding to the columns of S.
%%    If no return value is requested, the spectrogram is displayed instead.
%%
%% Global variables
%%    spectrogram_{window,step,maxF,nF,shape,minE,maxE} can override
%%    the default values with your own.
%%
%% To make a good spectrogram, generating spectral slices is only half
%% the problem.  Before you generate them, you must first choose your
%% window size, step size and FFT size.  A wide window shows more
%% harmonic detail, a narrow window shows more formant structure.  This
%% defines your time-frequency resolution. Step size controls the
%% horizontal scale of the spectrogram. Decrease it to stretch, or
%% increase it to compress. Certainly, increasing step size will reduce
%% time resolution, but decreasing it will not improve it much beyond
%% the limits imposed by the window size (you do gain a little bit,
%% depending on the shape of your window, as the peak of the window
%% slides over peaks in the signal energy).  The range 1-5 msec is good
%% for speech. Finally, FFT length controls the vertical scale, with
%% larger values stretching the frequency range.  Clearly, padding with
%% zeros does not add any information to the spectrum, but it is a
%% cheap, easy and good way to interpolate between frequency points, and
%% can make for prettier spectrograms.
%%
%% After you have generated the spectral slices, there are a number of
%% decisions for displaying them.  Firstly, the entire frequency range
%% does not need to be displayed.  The frequency range of the FFT is
%% determined by sampling rate.  If most of your signal is below 4 kHz
%% (in speech for example), there is no reason to display up to the
%% Nyquist frequency of 10 kHz for a 20 kHz sampling rate.  Next, there
%% is the dynamic range of the signal.  Since the information in speech
%% is well above the noise floor, it makes sense to eliminate any
%% dynamic range at the bottom end.  This is done by taking the max of
%% the normalized magnitude and some lower limit such as -40 dB.
%% Similarly, there is not much information in the very top of the
%% range, so clipping to -3 dB makes sense there. Finally, there is the
%% choice of colormap.  A brightness varying colormap such as copper or
%% bone gives good shape to the ridges and valleys.  A hue varying
%% colormap such as jet or hsv gives an indication of the steepness of
%% the slopes.

%% TODO: Accept vector of frequencies at which to sample the signal.
%% TODO: Consider accepting maxF (values > 0), shape (value is string)
%% TODO:    and dynamic range (values <= 0) in any order.
%% TODO: Consider defaulting step and maxF so that the spectrogram is
%% TODO:    an appropriate size for the screen (eg, 600x100).
%% TODO: Consider drawing in frequency/time grid;
%% TODO:    (necessary with automatic sizing as suggested above)
%% TODO: Consider using step vs. [nT, nF] rather than maxF vs [maxF, nF]
%% TODO: Figure out why exist() is so slow: 50 ms vs 1 ms for lookup.

function [S, f, t] = spectrogram(x, Fs, window, step, minF, maxF, shape, minE)
%      spectrogram_window=30;
%      spectrogram_step=5;
%      spectrogram_maxF=4000;
%      spectrogram_shape='hanning';
%      spectrogram_minE=-40;
%      spectrogram_nF=1;
%       spectrogram_maxE=0;
    
  maxE=0;
  step_n = fix(step*Fs/1000);    % one spectral slice every step ms
    
  %% generate window from duration and shape function name
  win_n = fix(window*Fs/1000);
  
  if shape(length(shape)) == ')' 
    shape = sprintf(shape, win_n);
  else
    shape = [shape '(' num2str(win_n) ')'];
  end
  win_vec = eval([shape]);
  if size(win_vec,2) ~= 1
    win_vec = win_vec'; end
  if size(win_vec,2) ~= 1 || size(win_vec,1) ~= win_n
    %error("spectrogram %s did not return a window of length %d", \ shape, win_n);
  end
	  
  %% FFT length from size of window and number of freq. pts requested
  fft_n = 2^nextpow2(win_n);    % next highest power of 2
  dF = Fs/fft_n;                % freq. step with current fft_n
  nF = ceil(maxF(1)/dF);        % freq. pts with current fft_n,maxF
  if ~isempty(minF)           % make sure there are at least n freq. pts
    if minF > nF             % if not enough
      dF = maxF/minF;            % figure out what freq. step we need
      fft_n = 2^nextpow2(Fs/dF);   % figure out what fft_n this requires
      dF = Fs/fft_n;               % freq. step with new fft_n
      nF = ceil(maxF/dF);          % freq. pts with new fft_n,maxF
    end
  end

  %% build matrix of windowed data slices
  offset = 1:step_n:length(x)-win_n;
  S = zeros (fft_n, length(offset));
  for i=1:length(offset)
    S(1:win_n, i) = x(offset(i):offset(i)+win_n-1) .* win_vec;
  end

  %% compute fourier transform
  S = fft(S);
  S = abs(S(1:nF,:));        % select the desired frequencies
  S = S/max(S(:));           % normalize magnitude so that max is 0 dB.
  S = max(S, 10^(minE/10));  % clip below minF dB.
  S = min(S, 10^(maxE/10));  % clip above maxF dB.

  f = [minF:Fs/fft_n:maxF];
  t = offset/Fs;
%    if nargout==0
%      imagesc(f,t,20*log10(flipud(S)));
%    else
%  end

end
