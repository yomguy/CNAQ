function plot_mes(t, f, f_s, f_min, f_max, sig_exc, sig_mes, rep_imp_mes, spec_mes, spec_exc, id, voice, group, comment, i);

len_spec_mes = length(spec_mes);
%spec = spec(1:len_spec);

% Time
figure;
subplot(2,1,1);
plot(t, sig_mes);
%semilogx(t, sig_mes);
axis([0 t(length(t)) min(sig_mes)-0.01 max(sig_mes)+0.01]);
%axis([1 t(length(t)) min(sig_mes)-0.01 max(sig_mes)+0.01]);
xlabel('Temps (s)');
ylabel('Amplitude');
title(['Signal temporel mesuré (groupe: ' group ', id: ' id ', voie : ' voice ')']);
grid on;

subplot(2,1,2);
rep_imp_mes = real(rep_imp_mes);
len_ri = length(rep_imp_mes);
t_ri = [-len_ri/(2*f_s):1/f_s:len_ri/(2*f_s)];
t_ri = t_ri(2:length(t_ri));
plot(t_ri, rep_imp_mes);
%semilogx(t, sig_mes);
axis([t_ri(1) t_ri(len_ri) min(rep_imp_mes)-0.01 max(rep_imp_mes)+0.01]);
%axis([1 t(length(t)) min(sig_mes)-0.01 max(sig_mes)+0.01]);
xlabel('Temps (s)');
ylabel('Amplitude');
title(['Réponse impulsionnelle mesurée (groupe: ' group ', id: ' id ', voie : ' voice ')']);
grid on;


% Freq
f_max_list = find(f > f_max);
f_max_ind = f_max_list(1);
f_min_list = find(f < f_min);
f_min_ind = f_min_list(length(f_min_list));

figure;
subplot(2,1,1);
spec_mes_log = 10*log10(abs(spec_mes));
semilogx(f, smooth(spec_mes_log,7));
axis([f_min f_max min(spec_mes_log(f_min_ind:f_max_ind-1000))-6 max(spec_mes_log(f_min_ind:f_max_ind))+6]);
xlabel('Fréquence (Hz)');
ylabel('Amplitude (dB)');
title(['Module de la fonction de transfert (groupe: ' group ', id: ' id ', voie : ' voice ')']);
grid on;

subplot(2,1,2);
angle_exc = angle(spec_exc);
angle_mes = angle(spec_mes);
ang = unwrap(angle_mes - angle_exc) + 2*pi;
semilogx(f, smooth(ang,7));
axis([f_min f_max min(ang(f_min_ind:f_max_ind)) max(ang(f_min_ind:f_max_ind))]);
grid on;
xlabel('Fréquence (Hz)');
ylabel('Phase (rad)');
title(['Phase de la fonction de transfert (groupe: ' group ', id: ' id ', voie : ' voice ')']);

