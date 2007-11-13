%Fr�quences de r�sonance issues de la mesure
frhp=20; % fr�quence de r�sonance du Hp seul
frb=35; % fr�quence de r�sonance du Hp sur caisson clos
frhpm=14; % fr�quence de r�sonance du Hp + masse ajout�e
frbm=23.12; %fr�quence de r�sonance du Hp sur caisson clos + masse ajout�e

%Pulsations correspondantes
omrhp=2*pi*frhp;
omrb=2*pi*frb;
omrhpm=2*pi*frhpm;
omrbm=2*pi*frbm;

%Donn�es Physiques
sd=352e-4; %Surface de la membrane m2
V=0.037%(0.395-0.06)^3-0.001; % Volume du caisson clos m3
Ma=0.181 %masse ajout�e kg

kb=1.4*1.0135e5/V*sd^2; %Raideur du caison clos N/m

disp('D�termination HP seul et caisson clos')
Cms1=1/kb*(omrb^2/omrhp^2-1)
%mms1=1/omr^2/Cms
Mms1=1/omrb^2*(1/Cms1+kb)
% frth=1/2/pi/sqrt(0.1353*0.52e-3)
% frm=1/2/pi/sqrt(Cms*mms1)

disp ('D�termination HP seul et HP + masse')
Mms2=Ma/(omrhp^2/omrhpm^2-1)
Cms2=1/(Mms2+Ma)/omrhpm^2

disp('D�termination HP + masse et Hp clos')
Mms3=(kb+Ma*omrhpm^2)/(omrb^2-omrhpm^2)
Cms3=1/(Mms3+Ma)/omrhpm^2