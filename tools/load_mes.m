function load_mes(handless)

    [filename, pathname, filterindex] = uigetfile('*.mat', 'Pick a saved MAT file');
    load([pathname filename]);
    
    % Set data
    set(handless.username,'String',username);
    set(handless.home_dir_box,'String',home_dir);
    set(handless.comment,'String',comment);
    set(handless.id_title,'UserData',sig_exc);
    set(handless.ID,'UserData',sig_mes);
    set(handless.mes_on,'UserData',f_log);
    set(handless.close_button,'UserData',f_lin);
    set(handless.mes_on,'UserData', f);
    set(handless.plot,'UserData', t);
    set(handless.f_gen_min,'String', num2str(f_min));
    set(handless.f_gen_max,'String', num2str(f_max));
    set(handless.f_gen,'Value', f);
    %set(handless.freq_value,'String',num2str(f));
    set(handless.time_gen,'Value', time);
    %set(handless.time_value,'String',num2str(time));
    set(handless.gain_in,'Value', gain_in);
    set(handless.gain_out,'Value', gain_out);
    set(handless.gain_in_value,'String',num2str(gain_in));
    set(handless.gain_out_value,'String',num2str(gain_out));
    set(handless.freq_value,'String',num2str(f));
    set(handless.time_value,'String',num2str(time));
    set_fs(handless, f_s);
    set_nbits(handless, nbits);
    
end