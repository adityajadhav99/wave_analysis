function [mag, phase, frequencies, varargout] = generate_spectra(data, t, Tavg, varargin)
%GENERATE_SPECTRA generates the fft spectra of the given data
%   [mag, phase, frequencies] = generate_spectra(data, t)
%   MAG             FFT magnitude corresponding to each frequency
%   PHASE           phase corresponding to each frequency
%   FREQUENCIES     the frequencies evaluated by fft
%   
%   DATA            wave elevation data
%   t               corresponding time
%   Tavg            average timeperiod
% 
%   [mag, phase, frequencies] = generate_spectra(data,t,'PARAM',val) specifies optional parameter name/value pairs:
%        'Plot'      - Outputs the fft magnitude and phase plot. Default
%        value as false.


% Parse the input arguments
p = inputParser;
addParameter(p, 'Plot', false, @islogical);
addParameter(p, 'ComparePM', false, @islogical);
paramName = 'Smoothen';
defaultVal = 0;
addParameter(p,paramName,defaultVal)
parse(p, varargin{:});

fft_data = fft(data); % a + ib

mag = abs(fft_data);
phase = angle(fft_data);

% return the x axis 
N = numel(data);
frequencies = (0:1:N-1)*(1/N/mean(diff(t)));

% Plot the onesided FFT if requested
plot_flag = p.Results.Plot;

if plot_flag
%     frequencies = frequencies(1:floor(N/2)+1);
    set(0,'DefaultAxesFontName','Times New Roman')
    set(0,'DefaultAxesFontSize',14)
    set(0,'DefaultLineLineWidth',1.5)
    figure();
   
    subplot(1,2,1);
    hold on;
    grid on;
    plot(frequencies(1:floor(N/2)+1), mag(1:floor(N/2)+1));
    xlabel('Frequency (Hz)');
    ylabel('FFT magnitude');
    hold off;
   
    subplot(1,2,2);
    hold on;
    grid on;
    plot(frequencies(1:floor(N/2)+1), rad2deg(phase(1:floor(N/2)+1)));
    xlabel('Frequency (Hz)');
    ylabel('Angle (deg)');
    hold off;
    
end

% Compare PM if requested
pm_flag = p.Results.ComparePM;

if pm_flag

    aPM = 0.081;
    g = 9.81;
    fm = 0.77/Tavg;
    
    f = linspace(0,round(1/mean(diff(t))/2,1),100);
    S = (aPM*g^2/(2*pi)^4./(f.^5)) .* exp(-1.25*(fm./f).^4);

    set(0,'DefaultAxesFontName','Times New Roman')
    set(0,'DefaultAxesFontSize',14)
    set(0,'DefaultLineLineWidth',1.5)
    figure();
    hold on;
    grid on;
    plot(frequencies(1:floor(N/2)+1), mag(1:floor(N/2)+1)/2);
    plot(f,S);
    xlabel('f (hz)');
    ylabel('m^2/hz');
    hold off;
    
end

% we can perform smoothing here
if p.Results.Smoothen == 0

    windowSize = 30; 
    b = (1/windowSize)*ones(1,windowSize);
    a = 1;
    filtered_mag = filter(b,a,mag(1:floor(N/2)+1));

    set(0,'DefaultAxesFontName','Times New Roman')
    set(0,'DefaultAxesFontSize',14)
    set(0,'DefaultLineLineWidth',2.5)
    figure();
    hold on;
    grid on;
    plot(frequencies(1:floor(N/2)+1), mag(1:floor(N/2)+1));
    plot(frequencies(1:floor(N/2)+1),filtered_mag)
    xlabel('Frequency (Hz)');
    ylabel('FFT magnitude');
    legend('fft', 'moving average')
    hold off;
end
if p.Results.Smoothen == 1
    wt = lanc(200,1/50);
    lanc_filtered = conv(mag(1:floor(N/2)+1),wt,'same');

    set(0,'DefaultAxesFontName','Times New Roman')
    set(0,'DefaultAxesFontSize',14)
    set(0,'DefaultLineLineWidth',2)
    figure();
    hold on;
    grid on;
    plot(frequencies(1:floor(N/2)+1), mag(1:floor(N/2)+1));
    plot(frequencies(1:floor(N/2)+1),lanc_filtered)
    xlabel('Frequency (Hz)');
    ylabel('FFT magnitude');
    legend('fft', 'lanczos')
    hold off;
end
end

