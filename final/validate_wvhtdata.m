function validate_wvhtdata(data,t,varargin)
%VALIDATE_WVHTDATA Summary of this function goes here
%   Detailed explanation goes here
set(0,'DefaultAxesFontName','Times New Roman')
set(0,'DefaultAxesFontSize',14)
set(0,'DefaultLineLineWidth',1.5)

wave_hts    = data;
timeperiods = t;

sorted_wvhts = sort(wave_hts,'descend');

% first 1/n waves to calculate the significant wave height
n  = 10;
Hs = mean(sorted_wvhts(1:round(numel(wave_hts)/n)));
disp(['Significant waveheight calculated using highest 1/',num2str(n),'th waveheights is ',num2str(Hs), 'm']);
nbins     = 14;
bin_width = (max(wave_hts)-min(wave_hts))/nbins;

figure;
h_waveht = histogram(wave_hts,nbins);
binCenter = zeros(nbins,1);

for i=1:numel(h_waveht.BinEdges)-1
binCenter(i) = (h_waveht.BinEdges(i)+h_waveht.BinEdges(i+1))/2;
end

xlabel('$H (m)$','Interpreter','latex');
ylabel('number of data points');
title('Wave Height Histogram Plot');

p = inputParser;
addParameter(p, 'Compare_wvhtPDF', false, @islogical);
addParameter(p, 'Compare_wvhtPexceed', false, @islogical);
parse(p, varargin{:});

wvhtPDF_flag     = p.Results.Compare_wvhtPDF;
wvhtPexceed_flag = p.Results.Compare_wvhtPexceed;

% comparing the PDF of waveheights with Rayleigh Dist
if wvhtPDF_flag
    obs_ht_dist = h_waveht.Values/sum(h_waveht.Values)/bin_width;
    x = linspace(0,0.3,100);
    Hrms = rms(wave_hts);
    rayleigh_dist = (2*x/(Hrms^2)).*exp(-(x.^2)/Hrms^2);
    
    figure();
    hold on;
    grid on;
    plot(binCenter, obs_ht_dist,'square');
    plot(x, rayleigh_dist);
    xlabel('$H (m)$','Interpreter','latex');
    ylabel('$p(H)$','Interpreter','latex');
    legend("Observed Distribution","Rayleigh Distribution")
    title('Comparison of Distributions (Wave Heights)')
    hold off
end

% plotting the probability of exceedance
if wvhtPexceed_flag
    prob = [];
    data = h_waveht.Values/sum(h_waveht.Values);
    for i = 1:numel(data)
    prob(end+1) = sum(data(1:i));
    end
    p_exceed_obs = 1 - prob;
    
    % rayleigh probability of exceedance
    x = linspace(0,max(wave_hts),100);
    p_exceed_rayleigh = exp(-(x./Hrms).^2);
    
    figure();
    hold on;
    grid on;
    plot(linspace(0,max(wave_hts),numel(p_exceed_obs)), p_exceed_obs,'square');
    plot(x, p_exceed_rayleigh);
    xlabel('$H (m)$','Interpreter','latex');
    ylabel('$P(H)$','Interpreter','latex');
    legend("Observed Probability of exceedance","Rayleigh Probability of exceedance")
    title('Comparison of Distributions (Probability of exceedance)')
    hold off
end
end

