function testacqui(n)

if nargin < 1, n = 50; end
if n == 1, n=2; end
%signal generation
f_min=20;
f_max=20000;
lt=5;  

t=0:1/44100:lt;
sig=0.9*chirp(t,20,lt,20000,'logarithmic');
len_sig = length(sig);

%playrecord signal
for it = 1:n
        pause(0.1)
    inputbuffer = pa_wavplayrecord(sig',1,[44100],0,[1],[1],1,['asio']);
    Co=xcorr(inputbuffer',sig');
    [Y(it),I(it)] = max(Co);
    delai(it)=I(it)-len_sig;
       
end
mfv=mode(delai);
mfvt =num2str(mfv);
sprintf('%s','the most frequent delay is ', mfvt,' samples.')

%Plot results
plot(delai);
axis([1 n (min(delai)-2) (max(delai)+2)]);
figure()
plot(Y);
axis([1 n min(Y) max(Y)]);

