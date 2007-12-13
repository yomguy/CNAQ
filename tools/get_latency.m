function [delay, mfv,ecart] = get_latency(device, n)
% this function allows measuring the latency of the playrecord process
% where :
% 'device' is the integer number of the audio card address from the ASIO
% driver point of view (0 or 1, 2 etc...)
% 'n' is the number of generation/acquisition operations
% mfv: most found delay
% ecart: standard deviation on delay

    %if nargin < 1, n = 10; end
    %signal generation
    f_min=20;
    f_max=20000;
    lt=5;  
    t=0:1/44100:lt;
    sig=0.5*chirp(t,f_min,lt,f_max,'logarithmic');
    len_sig = length(sig);

    %playrecord signal
    for it = 1:n
        pause(1);
        inputbuffer = pa_wavplayrecord(sig',device,[44100],0,[1],[1],device,['asio']);
        Co = xcorr(inputbuffer',sig');
        [Y(it), I(it)] = max(Co);
        delay(it) = I(it)-len_sig;

    end
    
    mfv = mode(delay);
    ecart = std(delay);

