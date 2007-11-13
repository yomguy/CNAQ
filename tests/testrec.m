l_buffer = 2048;
f_e = 44100;
lt=5; %s
f_min=20;
f_max=20000;
n=50;  

t=0:1/44100:lt;
%sig=chirp(t,20,lt,20000,'logarithmic');
%pa_wavplay(sig', f_e, 1, 'asio')

for i=1:30
    tic
    buffer = pa_wavrecord(1, 1, l_buffer, 44100, 'asio');
    %oscmx(3,y);
    plot(buffer);
    axis([1 l_buffer -1 1]);
    drawnow
    toc
end