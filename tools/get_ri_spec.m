function [ri, spec] = get_spec_ri(f, sig_exc, sig_exc, f_s)
% Return the impulse response and the spectrum compute with the given method

    if mes_type == 1
        % Frequency method
        [rep_imp_exc, spec_exc] = fonc_trans(f, sig_exc, sig_exc);
    elseif mes_type == 2
        % Temporal method
        [rep_imp_exc, spec_exc] = RI_FT(f, sig_exc, sig_exc, f_s);
    end

end