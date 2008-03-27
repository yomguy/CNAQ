function measurement(handles)

    pause(0.2);
    device = get(handles.in_on_off,'UserData');
    latency = get(handles.save_button,'UserData');
    nfft = 32768;
    f_min = str2double(get(handles.f_gen_min,'String'));
    f_max = str2double(get(handles.f_gen_max,'String'));
    f_s = get_fs(handles);
    time = get(handles.time_gen,'Value');
    voices_in = get_voices_in(handles);
    voice_first = voices_in(1);
    voice_last =  voices_in(length(voices_in));
    gain_out = get(handles.gain_out,'Value');
    gain_out = 10^(gain_out/20);
    
    % Avoid Gibbs like phenomenon
    f0 = 1;
    f1 = f_min;
    f2 = f_max;
    f3 = f_s/2;
    fade_in_time = time/((log(f2/f0)/log(f1/f0))-1);
    fade_out_time = time*((log(f3/f1)/log(f2/f1))-1);  
    total_time = fade_in_time + time + fade_out_time;
    t = [0:1/f_s:total_time];
    
    % Remove clicks durring emission and oscillations in the spectral response
    len_win_in = fade_in_time * f_s;
    window = blackman(len_win_in);
    len_win_in = round(len_win_in/2);
    window_in = window(1:len_win_in);
    
    len_win_out = fade_out_time * f_s;
    window = blackman   (len_win_out);
    len_win_out = round(len_win_out/2);
    window_out = flipud(window(1:len_win_out));
    
    sig_exc = gain_out*chirp_farina(t,total_time,f0,f3);
    l_t = length(t);
    one(1:l_t-len_win_in-len_win_out) = 1;
    mask = [window_in' one window_out'];
    sig_exc = sig_exc.*mask;
    
    % Synchronizing
    zero = zeros(1,latency);
    % Zeros are added before and removed after
    sig_exc_z = [sig_exc zero];
    len_sig_exc = length(sig_exc);
    
    % Make all voices
    sig_out = [];
    for i=1:length(voices_in)
        sig_out(:,i) = sig_exc_z';
    end
    
    % Measure
    sig_mes = pa_wavplayrecord(sig_out, device, f_s, 0, voice_first, voice_last, device, 'asio');
    %    Usage:
    %      inputbuffer = pa_wavplayrecord(playbuffer,[playdevice],[samplerate],
    %                       [recnsamples], [recfirstchannel], [reclastchannel],
    %                       [recdevice], [devicetype])
    
    % Resynchro
    pause(0.1);
    len_sig_mes = length(sig_mes);
    size_sig_mes = size(sig_mes);
    n_col_sig_mes = size_sig_mes(2);
    sig_mes = sig_mes(latency+1:len_sig_mes,:);
    len_sig_mes = length(sig_mes);
    sig_exc = sig_exc';
    f = logspace(log10(f0), log10(f3), len_sig_mes)';
    
    % Save data
    set(handles.ID,'UserData',sig_mes);
    set(handles.id_title,'UserData',sig_exc);
    set(handles.mes_on,'UserData',f);
    set(handles.plot,'UserData',t);
    
end
