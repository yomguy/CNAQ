function [ri,ft]=fonc_trans(f, sig_exc, sig_mes);
%calcul d'une fonction de tranfert mesurée par l'interface CNACQ
%Sorties : fonction de transfert et réponse impulsionnelle 

% soustraction de la composante continue
DC = mean(sig_mes,1);
sig_mes = sig_mes - DC;
len_f = length(f);
f0 = f(1);
f1 = f(length(f));

% Methode du produit
%sig_exc_inv = sig_exc(len_f:-1:1)'.*f0./f';
%X = fft([sig_mes; zeros(length(sig_exc_inv)-1, 1)]);
%Y = fft([sig_exc_inv; zeros(length(sig_mes)-1, 1)]);
%spec=X.*Y;
%rep_imp = ifft(spec);

% Methode du quotient
%sig_exc = sig_exc(len_f:-1:1)'.*f0./f';
X = fft(sig_exc);
Y = fft(sig_mes);
ft = Y./X;
ri = ifft(ft);

% Methode par déconvolution
%[ft, r] = deconv(sig_mes, sig_exc);
