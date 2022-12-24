function [mag, phase, frequencies] = generate_spectra(data, t)
%GENERATE_SPECTRA Summary of this function goes here
%   Detailed explanation goes here
fft_data = fft(data); % a + ib

mag = abs(fft_data);
phase = angle(fft_data);

% return the x axis 
N = numel(data);
frequencies = (0:1:N-1)*(1/N/mean(diff(t)));

% we can perfor smoothing here
end

