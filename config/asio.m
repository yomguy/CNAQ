% Config For your ASIO audio card
% ================================

function [device, latency] = asio()

% The ASIO device number in the audio sytem
device = 1;  

% The number of samples in the buffer of the sound card
% (delay * f_s = latency time)
% It IS necessary that you compute this value BEFORE any measurement
% executing ./tools/get_latency.m in MATLAB like this :
% >> get_latency(DEVICE, N)
% where DEVICE is the device number (see above) and N the number of 
% successive measurements
% If this value is wrong, the phasis results might be also wrong...
% BE CAREFUL : your ASIO card MUST be ALONE on its IRQ (see Windows system
% settings)
latency = 579;