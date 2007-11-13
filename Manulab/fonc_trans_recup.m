function [RI,spec] = fonctrans_recup(filename);
%calcul d'une fonction de tranfert mesurée par l'interface CNACQ
%Sorties : fonction de transfert et réponse impulsionnelle 
load (filename);

% soustraction de la composante continue
DC=mean(sig_mes,1);
sig_mes=sig_mes-DC;
S=size(sig_mes);
NT=S(1);
Freq =logspace(log10(f_min), log10(f_max), NT)';
excinv=sig_exc(NT:-1:1).*f_min./Freq;
[RI,spec] =  fconv(sig_mes,excinv);
plot(sig_mes,'k');
hold on
plot(sig_exc,'r')
angleexc=unwrap(angle(fft(sig_exc)));
anglemes=unwrap(angle(fft(sig_mes)));
ang=anglemes-angleexc + 2*pi;
figure
plot(ang)


