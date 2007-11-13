l_buffer = 2048;
f_e = 44100;
lt=5; %s
f_min=20;
f_max=20000;
n=50;  

t=0:1/44100:lt;
sig=chirp(t,20,lt,20000,'logarithmic');
% sig=wavread('excitation');

for i = 1:n
    i
    pause(0.1)
    pa_wavplay(sig', f_e, 1, 'win')
end