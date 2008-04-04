function plot_main(handles)

    % Get data
    sig_mes = get(handles.ID,'UserData');
    sig_exc = get(handles.id_title,'UserData');
    f = get(handles.mes_on,'UserData');
    t = get(handles.plot,'UserData');
    f_min = str2double(get(handles.f_gen_min,'String'));
    f_max = str2double(get(handles.f_gen_max,'String'));
    f_s = get_fs(handles);
    size_sig_mes = size(sig_mes);
    n_col_sig_mes = size_sig_mes(2);
    
    % Get infos
    username = get(handles.username,'String');
    comment = get(handles.comment,'String');
    id = get(handles.ID,'String');
    mes_type = get(handles.mes_type,'Value');
            
    % Compute excitation spectrum    
    [rep_imp_exc, spec_exc] = get_ri_spec(f, sig_exc, sig_exc, f_s, mes_type);
    len_spec_exc = length(spec_exc);
    spec_exc = spec_exc(1:len_spec_exc/2);
    
    % Compute all Ris and specs
    for i=1:n_col_sig_mes
        voice = num2str(i);
        [rep_imp_mes, spec_mes] = get_ri_spec(f, sig_exc, sig_mes(:,i), f_s, mes_type);
        len_spec_mes = length(spec_mes);    
        spec_mes = spec_mes(1:len_spec_mes/2);
        % Plot results
        f_lin = [0:f_s/len_spec_mes:f_s/2];
        f_lin = f_lin(1:length(f_lin)-1);
        plot_mes(t, f_lin, f_s, f_min, f_max, sig_exc, sig_mes(:,i), rep_imp_mes, spec_mes, spec_exc, id, voice, username, comment, i);
    end

    set(handles.close_button,'UserData',f_lin');
    set(handles.plot,'UserData',t);

end
