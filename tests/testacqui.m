lt=2; %s
f_min=20;
f_max=20000;
n=50;

t=0:1/44100:lt;
sig=chirp(t,20,lt,20000,'logarithmic');
%sig2=wavread('excitation');

for i = 1:n
    i
    pause(0.1)
    inputbuffer = pa_wavplayrecord(sig',1,[44100],0,[1],[1],[1],['asio']);
    Co=crosscorr(sig',inputbuffer',length(inputbuffer)-1);
    [Y(i),I(i)] = max(Co);
    I(i)
end

plot(I);
axis([1 n (max(I)+2) (min(I)-2)]);
