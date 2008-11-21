function plot_main(handles)

    % Get data
    sig_mes = get(handles.ID,'UserData');
    sig_exc = get(handles.id_title,'UserData');
    f = get(handles.mes_on,'UserData');
    t = get(handles.plot,'UserData');
    f_min = str2double(get(handles.f_gen_min,'String'));
    f_max = str2double(get(handles.f_gen_max,'String'));
    fs_id = get(handles.f_s,'Value');
    f_s = get_fs(fs_id);
    nb_id = get(handles.nbits,'Value');
    nbits = get_nbits(nb_id);
    size_sig_mes = size(sig_mes);
    n_col_sig_mes = size_sig_mes(2);
    
    % Get infos
    username = get(handles.username,'String');
    comment = get(handles.comment,'String');
    id = get(handles.ID,'String');
    type = get(handles.analysis_type,'Value');
    method = get(handles.analysis_method,'Value');
    domain = get(handles.analysis_domain,'Value');
    analysis_input_sig = get(handles.analysis_input_sig,'Value');
    analysis_output_sig = get(handles.analysis_output_sig,'Value');
    analysis_input_ch = get(handles.analysis_input_ch,'Value');
    analysis_output_ch = get(handles.analysis_output_ch,'Value');
    r_c = str2double(get(handles.r_c,'String'));

    if analysis_input_sig == 1
      input_sig = sig_exc;
    elseif analysis_input_sig == 2
      input_sig = sig_mes;
    end
    if analysis_output_sig == 2
      output_sig = sig_exc;
    elseif analysis_output_sig == 1
      output_sig = sig_mes;
    end
    
    if type == 1
    % Transfer function
    
        % Compute excitation spectrum    
        [rep_imp_exc, spec_exc] = get_ri_spec(f, sig_exc, sig_exc, f_s, method);
        len_spec_exc = length(spec_exc);
        spec_exc = spec_exc(1:len_spec_exc/2);

        % Compute all Ris and specs
        %for i=1:n_col_sig_mes
            channel = num2str(i);
            [rep_imp_mes, spec_mes] = get_ri_spec(f, input_sig(:,analysis_input_ch), output_sig(:,analysis_output_ch), f_s, method);
            len_spec_mes = length(spec_mes);    
            spec_mes = spec_mes(1:len_spec_mes/2);
            % Plot results
            f_lin = [0:f_s/len_spec_mes:f_s/2];
            f_lin = f_lin(1:length(f_lin)-1);
            plot_mes(t, f_lin, f_s, f_min, f_max, input_sig(:,analysis_input_ch), output_sig(:,analysis_output_ch), rep_imp_mes, spec_mes, spec_exc, id, channel, username, comment, i, domain);
        %end
    end

    if type == 2
    % Impedance
        plot_impedance(output_sig, r_c, f_s, f_min, f_max, 'log');
    end
    
    set(handles.close_button,'UserData','f_lin');
    set(handles.plot,'UserData',t);

end
