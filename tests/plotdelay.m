function [delay, mfv,ecart]=plotdelay(device, n)
%this function allows measuring the lattency of the playrecord process for
%n generation/acquisition operations

%if nargin < 1, n = 10; end
%signal generation
[delay, mfv, ecart] = get_latency(device, n)

% % mfv=mode(delai);
% % ecart=std(delai);
% mfvt =num2str(mfv);
% sprintf('%s','the most frequent delay is ', mfvt,' samples.')

%Plot results
hist(delay);
title('delay distribution');
xlabel('delay (number of samples)');


