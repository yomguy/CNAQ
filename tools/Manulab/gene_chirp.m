function gene_chirp

load Parametres_Mesures

Size                 =  2^Para_Mesu.Prec     ;                                                                                              
Para_Mesu.Tps        =  (Size/Para_Mesu.Fs)      % Tps de Mesure   
Time                 =  [0:Size-1]./Para_Mesu.Fs                                       ;                                                                                                                                                      % Decalage de la Data.Fmini 
Freq                 =  logspace(log10(Para_Mesu.Fmin), log10(Para_Mesu.Fmax), Size)                ;              
w1                   =  2*pi*Para_Mesu.Fmin;
w2                   =  2*pi*Para_Mesu.Fmax;                                 
Stimulus             =  .9 *sin((w1*Para_Mesu.Tps)/log(w2/w1) * (exp(Time'/Para_Mesu.Tps*log(w2/w1))-1))      ;              
L                    =  floor(Size/100)*2                                         ;
Window               =  flattop(L)                                                ;                                  
Calc_Theo.Stimulus   =  [Window(1:L/2); ones(Size-L,1); Window(L/2+1:L)].*Stimulus;        
Calc_Theo.St_inv     =  Stimulus([Size:-1:1]) .* (Para_Mesu.Fmin./Freq')                   ;                        
Calc_Theo.Freq = Freq';
wavwrite(Calc_Theo.Stimulus,Para_Mesu.Fs ,16,'chirplog')
% Application du niveau de Mesure
% Calc_Theo.Stimulus   =  Calc_Theo.Stimulus * 10^(Para_Mesu.Nive/20)     ;

% Calcul de la reponse Impulse Theorique
% Calc_Theo.Parfait.IR    =  fconv(Calc_Theo.Stimulus, Calc_Theo.St_inv)         ; 

% Calcul de la FFT
% Calc_Theo.Parfait.FFT   =  20*log10(abs(fft(Calc_Theo.Parfait.IR)))     ;

% Calcul de l'échelle des fréquences
% Calc_Theo.Parfait.Fr    =   Para_Mesu.Fs/(length(Calc_Theo.Parfait.FFT))      ;
% Calc_Theo.Parfait.Freq  =   0:Calc_Theo.Parfait.Fr:Para_Mesu.Fs-Calc_Theo.Parfait.Fr                   ;

% Calcul de courbe de reponse avec Fenetrage Tempo
% [Val,Num_Max_Par]          =  max(abs(Calc_Theo.Parfait.IR))  ;
% Nombres_Ech                =  round(Para_Mesu.Tps_Fen/1000*Para_Mesu.Fs)                 ;
% Ech_Min_Par                =  round(Num_Max_Par-Nombres_Ech)                         ;
% Ech_Max_Par                =  round(Ech_Min_Par+2*Para_Mesu.Tps_Fen/1000*Para_Mesu.Fs)   ;
% IR_Par_Fen                 =  Calc_Theo.Parfait.IR(Ech_Min_Par:Ech_Max_Par)                ;
% Calc_Theo.Parfait.FFT_Fen  =  20*log10(abs(fft(IR_Par_Fen)))     ;

% Calcul de l'échelle des fréquences
% Calc_Theo.Parfait.Fr_Fen       =   Para_Mesu.Fs/(length(Calc_Theo.Parfait.FFT_Fen))      ;
% Calc_Theo.Parfait.Freq_Fen     =   0:Calc_Theo.Parfait.Fr_Fen:Para_Mesu.Fs-Calc_Theo.Parfait.Fr_Fen                   ;

% Fenetrage tempo des THD
% IR = Calc_Theo.Parfait.IR;
% Decal        = round((length(IR)/(2^15*2)*(32610-29865))/1.3);% 30% de marge
% [a,Num_Max]  = max(abs(IR));
% Fen          = blackman(Decal*2);   Demi_Fen     = Fen(1:Decal)';   Num_Debut    = Num_Max-Decal;
% Debut = zeros(1,Num_Debut); Nbs_Ones = length(IR)-length(Debut)-length(Demi_Fen);   Fin   = ones(1,Nbs_Ones);
% Fenetre = [Debut Demi_Fen Fin]';
% IR_Sans_THD = Fenetre.*IR;
% Calc_Theo.Parfait.IR_Sans_THD = IR_Sans_THD;

% Calcul de la FFT
% Calc_Theo.Parfait.FFT_Sans_THD   =  20*log10(abs(fft(Calc_Theo.Parfait.IR_Sans_THD)))     ;


save Calculs_Theoriques Calc_Theo 




function [window] = flattop(N)
a1 =  -1.93; a2 =   1.29; a3 = -0.388;  a4 =  0.028;        temp = [1:N]'/N;        window = 1 + a1*cos(2*pi*temp) + a2*cos(4*pi*temp) + a3*cos(6*pi*temp) + a4*cos(8*pi*temp);     window = window/max(window);

function [New_sign, Fs] = fconv(Old_sign, Cvfilter, Fs)
X = fft([Old_sign; zeros(length(Cvfilter)-1, 1)]);      Y = fft([Cvfilter; zeros(length(Old_sign)-1, 1)]);      New_sign = real(ifft(X.*Y));
