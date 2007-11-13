lt=5; %s
f_min=20;
f_max=20000;
n=50;  

t=0:1/44100:lt;
sig=0.9*chirp(t,20,lt,20000,'logarithmic');
len_sig = length(sig);
% sig=wavread('excitation');

for i = 1:n
    i
    pause(0.1)
    inputbuffer = pa_wavplayrecord(sig',0,[44100],0,[1],[1],0,['asio']);
    Co=crosscorr(sig',inputbuffer',length(inputbuffer)-1);
    [Y(i),I(i)] = max(Co);
    I(i)-len_sig
end

plot(I);
axis([1 n (min(I)+2) (max(I)-2)]);
figure()
plot(Y);
axis([1 n min(Y) max(Y)]);
