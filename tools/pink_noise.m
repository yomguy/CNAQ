function s = pink_noise(n)

% Generate a pink noise
% n : number of samples to synthesize

% Filter coefficients
B = [0.049922035 -0.095993537 0.050612699 -0.004408786];
A = [1 -2.494956002 2.017265875 -0.522189400];

nT60 = round(log(1000)/(1-max(abs(roots(A))))); % T60 est.
v = randn(1, n + nT60); % Gaussian white noise: N(0,1)
s = filter(B, A, v);    % Apply 1/F roll-off to PSD
s = 2*s(nT60+1:end);    % Skip transient response

end
