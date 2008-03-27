function load_mes(handles)

    [filename, pathname, filterindex] = uigetfile('*.mat', 'Pick a saved MAT file');
    load([pathname filename]);
    
    % Set data
    set(handles.username,'String',username);
    set(handles.home_dir_box,'String',home_dir);
    set(handles.comment,'String',comment);
    set(handles.id_title,'UserData',sig_exc);
    set(handles.ID,'UserData',sig_mes);
    set(handles.mes_on,'UserData',f_log);
    set(handles.close_button,'UserData',f_lin);
    set_fs(handles, f_s);
    set_nbits(handles, nbits);
    set(handles.mes_on,'UserData', f);
    set(handles.plot,'UserData', t);
    set(handles.f_gen_min,'String', num2str(f_min));
    set(handles.f_gen_max,'String', num2str(f_max));
    set(handles.f_gen,'Value', f);
    set(handles.freq_value,'String',num2str(f));
    set(handles.time_gen,'Value', time);
    set(handles.time_value,'String',num2str(time));
    set(handles.gain_in,'Value', gain_in);
    set(handles.gain_out,'Value', gain_out);
    set(handles.gain_in_value,'String',num2str(gain_in));
    set(handles.gain_out_value,'String',num2str(gain_out));
    
end