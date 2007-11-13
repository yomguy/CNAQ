function s = chirp_farina(t, t1, f0, f1)
    s = sin(2*pi*(f0*t1)/log(f1/f0) * (exp(t'/t1*log(f1/f0))-1))';
   