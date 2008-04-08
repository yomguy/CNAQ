function monitor(handles)

    device = get(handles.in_on_off,'UserData');
    buffer = 8192;
    window = hanning(buffer);
    fs_id = get(handles.f_s,'Value');
    f_s = get_fs(fs_id);
    time = buffer/f_s;
    t = [0:1/f_s:time-1/f_s];
    
    f_min = str2double(get(handles.f_gen_min,'String'));
    f_max = str2double(get(handles.f_gen_max,'String'));
    freq = 2*(f_max-f_min)/buffer;
    f = [0:f_s/buffer:f_s/2];
    f = f(1:length(f)-1);
    voices_in = get_voices_in(handles);
    voice_first = voices_in(1);
    voice_last =  voices_in(length(voices_in));
        
    while get(handles.in_on_off,'Value') == 1
        % TIME_GEN
        %sig_in = wavrecord(buffer,f_s,2);
        sig_in = pa_wavrecord(voice_first, voice_last, buffer, f_s, device, 'asio');
        sig_in = sig_in(:,1);
        axes(handles.plot_in_temp);
        cla;
        %sig = sin(2*pi*10*t);
        plot(t,sig_in);
        grid on;
        
        % FREQ
        axes(handles.plot_in_freq);
        cla;
        fft_in = fft(sig_in.*window,buffer);
        log_abs_fft_in = 20*log10(2*abs(fft_in(1:round(buffer/2)))/buffer);
        semilogx(f,log_abs_fft_in);
        %axis([f_min f_max min(log_abs_fft_in) max(log_abs_fft_in)]);
        axis([f_min f_max -120 0]);
        grid on;
        drawnow;
        pause(0.01);
    end

end