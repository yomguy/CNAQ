function [S, f, t] = spectro2hd(s, f_s, f_max, n_harm)

    ncmap = 128; % number of points for colormap
    step = 5;   % spectral slice period (ms)
    % step_length = fix(5*Fs/1000);
    window = 100;   % filter window (ms)
    % window = fix(40*Fs/1000);
    noise_floor = -60; % (dB)
    
    [S, f, t] = spectrogram(s, f_s, window, step, f_max, 'hanning', noise_floor);
    S = 20*log10(S);
    colormap(jet(ncmap));
    
%      f=flipud(f');
%      img = imagesc(t, f, S);
%      
%      
    
    t_0 = t(1);
    t_n = t(length(t));
    f_0 = f(1);
    f_n = f(length(f));
        
    mesh(t, f, S);
    view([0,90]);
    shading interp;
    colorbar;
    axis([t_0 t_n f_0 f_n]);
    set(gca,'YScale','log');
    
    for t_i=1:length(t)
        f_1=f_0*exp((t_i/t_0)*log(f_n/f_0));
        for h_i=1:n_harm
            f_i = h_i*f_1;
            h(t_i,h_i)=S()
%      
%      pcolor(abs(S));
%      colorbar;
%      S(1:10,1:10)
end
