% Cette routine permet de comparer trois méthodes de traitement
% des sinus glissants (glissement logarithmique)
% Le signal d'excitation est généré selon la méthode proposée par Farina
% les trois méthodes de traitement sont :
% - Fonction de Transfert 
% - Déconvolution par filtre inverse
% - Déconvolution par filtre inverse avec passage dans le domaine
% fréquentiel
% Le système de test est un filtre passe-bas (type RC)
% les paramètres à faire varier sont :
% f1 et f2, les fréquences encadrant le signal généré
% nwin le nombre de points sur lequel on fenêtre le signal (en début et en fin)
% tmax : la durée du sinus glissant

clear all
close all
%input parameters
f1=1; % start frequency (Hz)
f2=20000; %end frequency(Hz)
tmax=.5; % excitation signal duration (s)
nwin=100; % windowing point number (half at the begining - half at the end)

%chirp generation (Farina)
fs=44100; % sampling frequency (Hz)
dt=1/fs; % sampling period 
t=0:dt:tmax; % time vector
om1=2*pi*f1; % begining pulsation
om2=2*pi*f2; % ending pulsation 
K=tmax*om1/log(om2/om1);
L=tmax/log(om2/om1);
yc=sin(K*(exp(t./L)-1)); % excitation signal (logarithmic swept signal)

%chirp windowing
win=hanning(nwin); 
siz=length(yc);
wint=ones(1,siz);
wint(1:nwin/2)=win(1:nwin/2);
wint(siz-nwin/2+1:siz)=win(nwin/2+1:nwin);
y=yc.*wint; %windowed swept sine

%Test on a low pass filter: processing of the filtered signal (iterative
% method)
fc=400; % cut-off frequency
RC=1/2/pi/fc; 
alf=dt/(dt+RC);
yf(1)=y(1);
for n=2:siz
   yf(n)=alf*y(n)+(1-alf)*yf(n-1); % filtered signal
end

%plot of the input and filtered signals
figure (1)
plot(t,y,'b'); 
xlabel('Time (s)');
hold on 
plot(t,yf,'r')
title('Input signals')
grid on
h = legend('Input signal','filtered signal',2);
set(h,'location','SouthWest')

% Impulse response: Inverse filter deconvolution (time domain)
yinv=fliplr(y);
fl=logspace(log10(f1),log10(f2),siz);
yinv=yinv./fl; % inverse filter
tic
IR=conv(yf,yinv); % processed impulse response
toc
sizi=length(IR);
is=fft(y).*conj(fft(yinv));
norm=sqrt(sum(abs(is.^2))/siz);
yeff=norm*sqrt(fs/2/(f2-f1));
IR=IR*fs/yeff;
t2=(-siz+1:1:siz-1).*dt;
figure(2)
subplot(3,1,1)
plot(t2,IR,'b')
grid on
xlabel('samples')
title('Impulse response')
ylabel('Deconvolution')
IRT=exp(-t2/RC)/RC;
IRT(1:siz-1)=0;
hold on 
plot(t2,IRT,'r')
legend('Processed','Theory',3)

% frequency response : Inverse filter deconvolution (time domain)
FR=fft(IR)/fs;
FR=FR(1:sizi/2);
fconv=0:fs/sizi:fs/2;
fconv=fconv(1:sizi/2);
LFR=20*log10(abs(FR));
figure(3)
subplot(3,1,1)
semilogx(fconv,LFR)
ylabel('Transfert function (decovonlution)')
title('Frequency response (dB)')
axis([10 20000 -40 +5])
grid on
hold on
FRT=abs(1./(1+j*2*pi*fconv*RC));
LFRT=20*log10(FRT);
semilogx(fconv,LFRT,'r')
xlabel('Frequency (Hz)')
legend('Processed','Theory',3)
imin=round(f1/fs*sizi)+1;
imax=round(f2/fs*sizi)+1;
E1=sqrt(sum(abs(FRT(imin:imax)-FR(imin:imax)).^2./(abs(FRT(imin:imax)).^2)))*100/(imax-imin+1);
E1t = strcat('Erreur quadratique :',num2str(E1,2),' %');
text(3000,-5,E1t);

%Transfer function method
specy=fft(y);
specyf=fft(yf);
TF=specyf./specy;
IR2=ifft(TF)*fs;
figure(2)
subplot(3,1,2)
% pad=zeros(1,siz-1);
% IR2=[pad IR2];
plot(t,IR2,'b')
grid on
hold on 
plot(t2,IRT,'r')
xlabel('samples')
ylabel('Inverse Transfer Function')
legend('Processed','Theory',3)
TF2=TF(1:siz/2);
f=0:fs/siz:fs/2-fs/siz;
LFR2=20*log10(abs(TF2));
figure(3)
subplot(3,1,2)
semilogx(f,LFR2)
axis([10 20000 -40 +5])
grid on
hold on
FRT2=abs(1./(1+j*2*pi*f*RC));
LFRT2=20*log10(FRT2);
semilogx(f,LFRT2,'r')
xlabel('Frequency (Hz)')
ylabel('Transfer Function')
legend('Processed','Theory',3)
% imin=round(f1/fs*sizi)+1;
% imax=round(f2/fs*sizi)+1;
% E2=sqrt(sum(abs(FRT(imin:imax)-TF2(imin:imax)).^2./(abs(FRT(imin:imax)).^2)))*100/(imax-imin+1);
% E2t = strcat('Erreur quadratique :',num2str(E2,2),' %');
% text(3000,-5,E2t);

% Impulse response: Inverse filter deconvolution (freq domain)
% yinv=fliplr(yc);
% fl=logspace(log10(f1),log10(f2),siz);
% yinv=yinv./fl; % inverse filter
% yinvf=yinv.*wint; %windowed inverse filter
% IR=conv(yf,yinvf); % processed impulse response
tic 
iRF=fft([yf, zeros(1,siz-1)]).*fft([yinv, zeros(1,siz-1)])/yeff;
IR3=real(ifft(iRF))*fs;
toc
% norm=sqrt(sum(abs(is.^2))/siz);
% yeff=norm*sqrt(fs/2/(f2-f1));
% scal=fs/yeff;
t2=(-siz+1:1:siz-1).*dt;
figure(2)
subplot(3,1,3)
plot(t2,IR3,'b')
grid on
xlabel('samples')
title('Impulse response')
ylabel('Deconvolution freq')
IRT=exp(-t2/RC)/RC;
IRT(1:siz-1)=0;
hold on 
plot(t2,IRT,'r')
legend('Processed','Theory',3)

% frequency response : Inverse filter deconvolution (freq domain)
FR3=iRF(1:sizi/2);
fconv=0:fs/sizi:fs/2;
fconv=fconv(1:sizi/2);
LFR3=20*log10(abs(FR3));
figure(3)
subplot(3,1,3)
semilogx(fconv,LFR3)
ylabel('Transfert function (deconv freq)')
title('Frequency response (dB)')
axis([10 20000 -40 +5])
grid on
hold on
FRT=abs(1./(1+j*2*pi*fconv*RC));
LFRT=20*log10(FRT);
imin=round(f1/fs*sizi)+1;
imax=round(f2/fs*sizi)+1;
E3=sqrt(sum(abs(FRT(imin:imax)-FR3(imin:imax)).^2./(abs(FRT(imin:imax)).^2)))*100/(imax-imin+1);
E3t = strcat('Erreur quadratique :',num2str(E3,2),' %');
text(3000,-5,E3t);
semilogx(fconv,LFRT,'r')
xlabel('Frequency (Hz)')
legend('Processed','Theory',3)
