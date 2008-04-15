function [S, f, t, f_1, h] = spectro2hd(s, f_s, f_min, f_max, n_harm)

    ncmap = 128; % number of points for colormap
    step = 10;   % spectral slice period (ms)
    % step_length = fix(5*Fs/1000);
    window = 50;   % filter window (ms)
    % window = fix(40*Fs/1000);
    noise_floor = -60; % (dB)
    n_harm = 4;
    
    [S, f, t] = spectrogram(s, f_s, window, step, f_min, f_max, 'hanning', noise_floor);
    S = 20*log10(S);
    colormap(jet(ncmap));
    
    size(t)
    size(f)
    size(S)
    t_0 = t(1);
    t_n = t(length(t));
    f_0 = f(1);
    f_n = f(length(f));
      
    S=flipud(S);
    f=flipud(f');
%      
    figure(1)
%    img = imagesc(t, f, S);

    mesh(t, f, S);
    view([0,90]);
    shading interp;
    colorbar;
    axis([t_0 t_n f_0 f_n]);
    set(gca,'YScale','log');
    
    for t_i=1:length(t)
        f_1(t_i)=f_0*exp((t(t_i)/t_n)*log(f_n/f_0));
        for h_i=1:n_harm
            f_i = h_i*f_1(t_i);
            [r,c,V] = findnearest(f_i,f,0);
            h(h_i,t_i)=S(r,t_i);
        end
    end
    
    figure(2)
    semilogx(f_1,h(1,:),'k')
    hold on
    semilogx(f_1,h(2,:),'r')
    semilogx(f_1,h(3,:),'b')
    semilogx(f_1,h(4,:),'g')

    
%      pcolor(abs(S));
%      colorbar;
%      S(1:10,1:10)
end
