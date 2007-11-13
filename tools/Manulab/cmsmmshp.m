%Fréquences de résonance issues de la mesure
frhp=20; % fréquence de résonance du Hp seul
frb=35; % fréquence de résonance du Hp sur caisson clos
frhpm=14; % fréquence de résonance du Hp + masse ajoutée
frbm=23.12; %fréquence de résonance du Hp sur caisson clos + masse ajoutée

%Pulsations correspondantes
omrhp=2*pi*frhp;
omrb=2*pi*frb;
omrhpm=2*pi*frhpm;
omrbm=2*pi*frbm;

%Données Physiques
sd=352e-4; %Surface de la membrane m2
V=0.037%(0.395-0.06)^3-0.001; % Volume du caisson clos m3
Ma=0.181 %masse ajoutée kg

kb=1.4*1.0135e5/V*sd^2; %Raideur du caison clos N/m

disp('Détermination HP seul et caisson clos')
Cms1=1/kb*(omrb^2/omrhp^2-1)
%mms1=1/omr^2/Cms
Mms1=1/omrb^2*(1/Cms1+kb)
% frth=1/2/pi/sqrt(0.1353*0.52e-3)
% frm=1/2/pi/sqrt(Cms*mms1)

disp ('Détermination HP seul et HP + masse')
Mms2=Ma/(omrhp^2/omrhpm^2-1)
Cms2=1/(Mms2+Ma)/omrhpm^2

disp('Détermination HP + masse et Hp clos')
Mms3=(kb+Ma*omrhpm^2)/(omrb^2-omrhpm^2)
Cms3=1/(Mms3+Ma)/omrhpm^2