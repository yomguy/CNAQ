function [Out_Freq,Out_dB] =  Lissage_Spl (In_Freq ,In_dB)
load Parametres_Affichages
load Parametres_Mesures
Nb_dB         =   Para_Affi.RF.Nb_dB;
Nb_dB_Affiche =   48;
dbmin         =   -500;
% Diminution du nbs de point avant le lissage pour eviter 
rapport       =  round(Nb_dB_Affiche*10/Para_Affi.RF.Nb_dB);
liste_f_log   =  freqoctav(Para_Affi.RF.Fmin*0.3,Para_Mesu.Fs/1.5,Nb_dB_Affiche*10);
liste_db_log  =  interp1  (In_Freq ,In_dB, liste_f_log,'cubic',dbmin);

db_log_smooth =  smooth(liste_db_log,rapport);

db_ok2        =  db_log_smooth(2 : length(db_log_smooth)-1);   %elim ination du 1° et dermier point
f_ok2         =  liste_f_log  (2 : length(liste_f_log)-1);

Out_Freq      =  freqoctav(Para_Mesu.Fmin,Para_Mesu.Fmax,Nb_dB_Affiche);

Out_dB        =  interp1(f_ok2,db_ok2,Out_Freq,'cubic',dbmin);

function [valf]=freqoctav(fmin,fmax,db)
syms nx;    nf=floor(log(fmax/fmin)*db/log(2))+2;   for i = 1:nf;  valf(i) = fmin*2^((i-1)/db);     end
