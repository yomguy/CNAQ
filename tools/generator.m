function generator(handles)

    f_min = str2double(get(handles.f_gen_min,'String'));
    f_max = str2double(get(handles.f_gen_max,'String'));
    sig_type = get(handles.sig_type,'Value');
    sin_freq = get(handles.f_gen,'Value');
    fs_id = get(handles.f_s,'Value');
    nb_id = get(handles.nbits,'Value');
    f_s = get_fs(fs_id);
    nbits = get_nbits(nb_id);
    time = get(handles.time_gen,'Value');
    ch_out_id = get(handles.channels_out,'Value');
    channels_out = get_channels_in(ch_out_id);
    gain_out = get(handles.gain_out,'Value');
    gain_out = 10^(gain_out/20);
    t = [0:1/f_s:time];
    n_t = length(t);
    
    if sig_type == 1
        % SINUS
        sig = gain_out*sin(2*pi*sin_freq*t);
    elseif sig_type == 2
        % CHIRP
        sig = gain_out*chirp(t,f_min,time,f_max,'logarithmic');
    elseif sig_type == 3
        % WHITE NOISE
        sig = gain_out*white_noise(n_t);
    elseif sig_type == 4
        % PINK NOISE
        sig = gain_out*pink_noise(n_t);
    end
  
    sig_out = [];
    for i=1:length(channels_out)
        sig_out(:,i) = sig';
    end

    % Matlab way (needs Data Acquisition Toolbox)
%      ao = analogoutput('winsound', 0);
%      addchannel(ao, channels_out);
%      set(ao, 'StandardSampleRates', 'Off');
%      set(ao, 'SampleRate', f_s);
%      
%      if get(handles.gen_on_off,'Value') == 1
%          putdata(ao, sig_out);
%          start(ao);
%          set(handles.gen_on_off,'Value',0);
%      end
%      %delete(ao);

    % PA way but can't work with monitor !...
    %pa_wavplay(sig_out',f_s,0,'asio');
    
    % Winsoud way to get the scope running...
    sound(sig_out',f_s);
    pause(0.1);

end
