function specplot(ficpath,fic,sens,var)
% plots the spectrogram of a signal
% distributed as a part of fazplot
% Author : Guillaume Pellerin

% PARAMETERS
% ficpath: the path folder of the wav file
% fic: the wav file
% sens: la sensibilté du préampli micro (V/Pa)
% var: nom de la variable

[y,fs,nbits,opts] = wavread([ficpath fic]);
sens
y=y./sens;
ly=length(y);
nfft=16384;
fe=44100;
f=[0:nfft/2]*fe/nfft;
t=[0:ly-1]/fe;
nwin=nfft;
wind=hanning(nwin);

% ajout des zeros
p=round(log(ly)/log(2));
epsil=(2^p-ly);
ynew=[y' zeros(1,epsil)]';

% Calcul des spectres
fy=pwelch(ynew,wind,0,nfft,fe);
fya=unwrap(angle(fft(ynew,nfft)));
aspect=20*log10(abs(fy(1:(nfft/2+1))).^0.5./2e-5);
fya=fya(1:(nfft/2+1));
maxaspect=max(aspect);
maxy=max(max(y),abs(min(y)));

% plots
figure();
plot(t,y,'k');
axis([0 max(t) -(maxy*1.1) (maxy*1.1)]);
xlabel('Temps (s)');
ylabel('Amplitude (Pa)');
title(['Signal temporel : ' fic ' - paramètre : ' var]);
grid on;

figure();
semilogx(f,aspect,'k');
axis([10 max(f) 0 (maxaspect+10)]);
xlabel('Fréquence (Hz)');
ylabel('Lp (dB SPL)');
title(['Module de la réponse fréquentielle, signal : ' fic ' - paramètre : ' var]);
grid on;

figure();
semilogx(f,fya,'k');
axis([10 max(f) min(fya) max(fya)]);
grid on;
xlabel('Fréquence (Hz)');
ylabel('Phase (rad)');
title(['Phase de la réponse fréquentielle, signal : ' fic ' - paramètre : ' var]);

end
