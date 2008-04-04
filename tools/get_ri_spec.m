function [ri, spec] = get_spec_ri(f, sig_exc, sig_mes, f_s, mes_type)
% Return the impulse response and the spectrum compute with the given method
    
    if mes_type == 1
        % Frequency method
        [ri, spec] = fonc_trans(f, sig_exc, sig_mes);
    elseif mes_type == 2
        % Temporal method
        [ri, spec] = RI_FT(f, sig_exc, sig_mes, f_s);
    end

end