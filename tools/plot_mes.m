function plot_mes(t, f, f_s, f_min, f_max, sig_exc, sig_mes, rep_imp_mes, spec_mes, spec_exc, id, channel, group, comment, i, domain);

len_spec_mes = length(spec_mes);
%spec = spec(1:len_spec);

if domain == 1
    % Freq
    f_max_list = find(f > f_max);
    f_max_ind = f_max_list(1);
    f_min_list = find(f < f_min);
    f_min_ind = f_min_list(length(f_min_list));

    figure;
    subplot(2,1,1);
    spec_mes_log = 10*log10(abs(spec_mes));
    semilogx(f, spec_mes_log);
    axis([f_min f_max min(spec_mes_log(f_min_ind:f_max_ind-1000))-6 max(spec_mes_log(f_min_ind:f_max_ind))+6]);
    xlabel('Frequency (Hz)');
    ylabel('Magnitude (dB)');
    title(['Modulus of the transfer function (group: ' group ', id: ' id ', channel : ' channel ')']);
    grid on;

    subplot(2,1,2);
    angle_exc = angle(spec_exc);
    angle_mes = angle(spec_mes);
    ang = unwrap(angle_mes - angle_exc) + 2*pi;
    semilogx(f, ang);
    axis([f_min f_max min(ang(f_min_ind:f_max_ind)) max(ang(f_min_ind:f_max_ind))]);
    grid on;
    xlabel('Frequency (Hz)');
    ylabel('Phasis (rad)');
    title(['Phasis of the transfer function (group: ' group ', id: ' id ', channel : ' channel ')']);

elseif domain == 2
    % Time
    figure;
    subplot(2,1,1);
    size(sig_mes)
    plot(t, sig_mes);
    %semilogx(t, sig_mes);
    axis([0 t(length(t)) min(sig_mes)-0.01 max(sig_mes)+0.01]);
    %axis([1 t(length(t)) min(sig_mes)-0.01 max(sig_mes)+0.01]);
    xlabel('Time (s)');
    ylabel('Magnitude');
    title(['Measured temporal signal (group: ' group ', id: ' id ', channel : ' channel ')']);
    grid on;

    subplot(2,1,2);
    len_ri = length(rep_imp_mes);
    t_ri = [(-len_ri)/(2*f_s):1/f_s:(len_ri)/(2*f_s)];
    %t_ri = [0:1/f_s:len_ri/f_s];
    t_ri = t_ri(1:length(t_ri)-1);
    plot(t_ri,rep_imp_mes);
    axis([-t_ri(len_ri) t_ri(len_ri) min(rep_imp_mes)-0.01 max(rep_imp_mes)+0.01]);
    xlabel('Time (s)');
    ylabel('Magnitude');
    title(['Measured impulse response (group: ' group ', id: ' id ', channel : ' channel ')']);
    grid on;


elseif domain == 3
    % Time - frequency
    spectro2hd(sig_mes,f_s,f_min,f_max,5);


end



