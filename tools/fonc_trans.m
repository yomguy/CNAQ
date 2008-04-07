function [ri,ft]=fonc_trans(f, sig_exc, sig_mes, f_s)
%calcul d'une fonction de tranfert mesurée par l'interface CNAQ
%Sorties : fonction de transfert et réponse impulsionnelle 

% soustraction de la composante continue
DC = mean(sig_mes,1);
sig_mes = sig_mes - DC;
len_f = length(f);

% Methode du quotient
X = fft([sig_exc;zeros(len_f-1,1)]);
Y = fft([zeros(len_f-1,1);sig_mes]);
ft = Y./X;
ri = real(ifft(ft))*f_s;
%ri = [0; ri(1:length(ri)-1)];