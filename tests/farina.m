% Cette routine permet de comparer deux m�thodes de traitement
% des sinus glissants (glissement logarithmique)
% Le signal d'excitation est g�n�r� selon la m�thode propos�e par Farina
% les deux m�thodes de traitement sont :
% - Fonction de Transfert 
% - D�convolution par filtre inverse
% Le syst�me de test est un filtre passe-bas (type RC)
% les param�tres � faire varier sont  :
% f1 et f2, les fr�quences encadrant le signal g�n�r�
% nwin le nombre de points sur lequel on fen�tre le signal (en d�but et en fin)
% tmax : la dur�e du sinus glissant


clear all
close all
%param�tres � faire varier
f1=5; %fr�quence de d�part du sinus glissant (Hz)
f2=8000; %fr�quence d'arriv�e du sinus glissant (Hz)
nwin=400; % somme des nombres de point � fen�trer en d�but et fin de signal
tmax=0.5; %dur�e du sinus glissant (s)

%G�n�ration du chirp (Farina)
fs=44100; %fr�quence d'�chantillonnage (Hz)
dt=1/fs; %pas temporel
t=0:dt:tmax; %vecteur temps
om1=2*pi*f1; %pulsation basse
om2=2*pi*f2; %pulsation haute
K=tmax*om1/log(om2/om1);
L=tmax/log(om2/om1);
yc=sin(K*(exp(t./L)-1)); %Sinus glissant (Farina)

%fen�trage du chirp
win=hanning(nwin);
siz=length(yc);
wint=ones(1,siz);
wint(1:nwin/2)=win(1:nwin/2);
wint(siz-nwin/2+1:siz)=win(nwin/2+1:nwin);
y=yc.*wint; %Sinus glissant fen�tr�
% yinv=fliplr(y);
% co=conv(y,yinv);
% figure
% plot(co)

%test sur filtre passe-bas : contruction du signal filtr� par m�thode
%r�cursive
fc=400; %fr�quence de coupuer du filtre
RC=1/2/pi/fc; 
alf=dt/(dt+RC);
yf(1)=y(1);
for n=2:siz
    yf(n)=alf*y(n)+(1-alf)*yf(n-1); %Signal filtr�
end
figure (1)
plot(t,yf)
xlabel('Time (s)')
title('Input signal')
grid on

%D�convolution par filtre inverse en temporel (Farina)
yinv=fliplr(yc);
fl=logspace(log10(f1),log10(f2),siz);
yinv=yinv./fl;
yinvf=yinv.*wint;
IR=conv(yf,yinvf);
figure(2)
subplot(2,1,1)
plot(IR)
grid on
xlabel('samples')
title('Impulse response')
ylabel('Deconvolution')
sizi=length(IR);
FR=fft(IR);
FR=FR(1:sizi/2);
fconv=0:fs/sizi:fs/2;
fconv=fconv(1:sizi/2);
LFR=20*log10(abs(FR));
autoc=conv(yc,yinv);
yeff=sqrt(sum(autoc.^2)*fs/2/(f2-f1));
% yeff=sizi/2*(f2-f1)/fs
% yeff=1
sf=20*log10(yeff);
LFR=LFR-sf;
figure(3)
subplot(2,1,1)
% title('Frequency response (dB)')
semilogx(fconv,LFR)
title('Frequency response (dB)')
axis([10 20000 -40 +5])
grid on
hold on
FRT=abs(1./(1+j*2*pi*fconv*RC));
LFRT=20*log10(FRT);
semilogx(fconv,LFRT,'r')
xlabel('Frequency (Hz)')
legend('Processed','Theory',3)

%M�thode de la fonction de transfert
specy=fft(y);
specyf=fft(yf);
TF=specyf./specy;
IR2=fftshift(ifft(TF));
figure(2)
subplot(2,1,2)
plot(IR2)
grid on
xlabel('samples')
ylabel('Inverse Transfer Function')
TF2=TF(1:siz/2);
f=0:fs/siz:fs/2;
f=f(1:siz/2);
LFR2=20*log10(abs(TF2));
figure(3)
subplot(2,1,2)
semilogx(f,LFR2)
axis([10 20000 -40 +5])
grid on
hold on 
FRT2=abs(1./(1+j*2*pi*f*RC));
LFRT2=20*log10(FRT2);
semilogx(f,LFRT2,'r')
xlabel('Frequency (Hz)')
legend('Processed','Theory',3)
