function [ri, spec] = get_spec_ri(f, sig_exc, sig_mes, f_s, method)
% Return the impulse response and the spectrum compute with the given method
    
    if method == 1
        % Frequency method
        [ri, spec] = fonc_trans(f, sig_exc, sig_mes, f_s);
    elseif method == 2
        % Temporal method
        [ri, spec] = RI_FT(f, sig_exc, sig_mes, f_s);
    end

end