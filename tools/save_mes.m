function save_mes(handles)

    % Get data
    id = get(handles.ID,'String');
    username = get(handles.username,'String');
    home_dir = get(handles.home_dir_box,'String');
    comment = get(handles.comment,'String');
    sig_exc = get(handles.id_title,'UserData');
    sig_mes = get(handles.ID,'UserData');
    f_log = get(handles.mes_on,'UserData');
    f_lin = get(handles.close_button,'UserData');
    fs_id = get(handles.f_s,'Value');
    nb_id = get(handles.nbits,'Value');
    f_s = get_fs(fs_id);
    nbits = get_nbits(nb_id);
    f = get(handles.mes_on,'UserData');
    t = get(handles.plot,'UserData');
    f_min = str2double(get(handles.f_gen_min,'String'));
    f_max = str2double(get(handles.f_gen_max,'String'));
    time = get(handles.time_gen,'Value');
    voices_in = get_voices_in(handles);
    gain_in = get(handles.gain_in,'Value');
    voices_out = get_voices_out(handles);
    gain_out = get(handles.gain_out,'Value');
    
    % Save it
    file = [home_dir '\' username '_' id '.mat'];
    save(file);
    
    % Clear big data
    % set(handles.ID,'UserData',[]);
    % set(handles.id_title,'UserData',[]);
    % set(handles.mes_on,'UserData',[]);
    
    % Increment ID
    increment_id(handles);

end