% Loudspeaker impedance post-processing from a 2 voice acquisition from CNAQ
% Copyright (C) Guillaume Pellerin

function plot_impedance(fic_resitance, fic_hp, R_c, option)

% fic_resistance : the (CNAQ) MAT file containing the transfert function of the
% resistance
% fic_hp = the (CNAQ) MAT file containing the the transfert function of the
% loudspeaker
% R_c = the value of the resistance (Ohm)
% option : 'lin' or 'log' to plot the frequency with a linear or
% logarithmic scale respectively

load(fic_resitance);
U_r = sig_mes(:,1);
I_r = sig_mes(:,1)/R_c;

load(fic_hp);
U_hp = sig_mes(:,1)-U_r;

%i = sig_mes(:,1);
%u = sig_mes(:,2);
li = length(I_r);
fi = fft(I_r);
fu = fft(U_hp);
fz = fu./fi;
f = [0:f_s/li:f_s];
f = f(1:li);

% get limit freq
f_max_list = find(f > f_max);
f_max_ind = f_max_list(1);
f_min_list = find(f < f_min);
f_min_ind = f_min_list(length(f_min_list));

figure
subplot(2,1,1);
data = smooth(abs(fz),20);
if option == 'lin'
    plot(f,data)
elseif option == 'log'
    semilogx(f,data)
end
axis([f_min f_max 0 max(data(f_min_ind:f_max_ind))])
xlabel('Fréquence (Hz)');
ylabel('Amplitude (Ohm)');
title(['Module de l impedance']);
grid on

subplot(2,1,2);
data = smooth(unwrap(angle(fz)),20);
if option == 'lin'
    plot(f,data)
elseif option == 'log'
    semilogx(f,data)
end
axis([f_min f_max min(data(f_min_ind:f_max_ind)) max(data(f_min_ind:f_max_ind))]);
xlabel('Fréquence (Hz)');
ylabel('Amplitude (Rad)');
title(['Phase de l impedance']);
grid on



