function [mfv,ecart]=getdelay(n)
% this function allows measuring the lattency of the playrecord process for
% n generation/acquisition operations
% mfv: most found delay
% ecart: standard deviation on delay
if nargin < 1, n = 10; end

%signal generation
f_min=100;
f_max=20000;
lt=5;  
t=0:1/44100:lt;
sig=0.9*chirp(t,f_min,lt,f_max,'logarithmic');
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
ecart=std(delai);

