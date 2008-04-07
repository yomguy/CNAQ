function [ri,ft]=fonc_trans(f, sig_exc, sig_mes);
%calcul d'une fonction de tranfert mesurée par l'interface CNAQ
%Sorties : fonction de transfert et réponse impulsionnelle 

% soustraction de la composante continue
DC = mean(sig_mes,1);
sig_mes = sig_mes - DC;
len_f = length(f);

% Methode du quotient
X = fft([sig_exc; zeros(len_f-1,1)]);
Y = fft([sig_mes; zeros(len_f-1,1)]);
ft = Y./X;
ri = real(ifft(ft));
