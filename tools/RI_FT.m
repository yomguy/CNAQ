function [ri,ft]=RI_FT(f, sig_exc, sig_mes)
%calcul d'une fonction de tranfert mesurée par l'interface CNAQ
%Sorties : fonction de transfert et réponse impulsionnelle 

% soustraction de la composante continue
DC = mean(sig_mes,1);
sig_mes = sig_mes - DC;
len_f = length(f);
% f0 = f(1);
% f1 = f(length(f));

% Methode du produit
siginv=fliplr(sig_exc)./f;
ft=fft([sig_mes; zeros(len_f-1,1)]).*fft([siginv; zeros(len_f-1,1)]);
ri=real(ifft(ft));

