function validate_data(data,t,varargin)
%VAIDATE_DATA Summary of this function goes here
%   Detailed explanation goes here

set(0,'DefaultAxesFontName','Times New Roman')
set(0,'DefaultAxesFontSize',14)
set(0,'DefaultLineLineWidth',1.5)

eta  = data;
time = t;

% visualizing data
figure();
hold on;
grid on;
plot(time, eta);
xlabel('time');
ylabel('$\eta (m)$','Interpreter','latex');
title('wave elevation');
hold off;

% demeaning elevation
eta     = eta - mean(eta);
std_dev = std(eta);
min_eta = min(eta);
max_eta = max(eta);

Hs = 4*std_dev;

nbins     = 17;
bin_width = (max(eta)-min(eta))/nbins;


figure;
h = histogram(eta,nbins);
binCenter = zeros(nbins,1);

for i=1:numel(h.BinEdges)-1
binCenter(i) = (h.BinEdges(i)+h.BinEdges(i+1))/2;
end

xlabel('$\eta$','Interpreter','latex');
ylabel('number of data points');
title('Histogram Plot');

p = inputParser;
addParameter(p, 'Compare_etaPDF', false, @islogical);
% addParameter(p, 'Compare_wvhtPDF', false, @islogical);
% addParameter(p, 'Compare_wvhtPexceed', false, @islogical);
parse(p, varargin{:});

etaPDF_flag      = p.Results.Compare_etaPDF;
% wvhtPDF_flag     = p.Results.Compare_etaPDF;
% wvhtPexceed_flag = p.Results.Compare_etaPDF;

if etaPDF_flag
    obs_dist   = h.Values/sum(h.Values)/bin_width;
    x          = linspace(round(min_eta,1),round(max_eta,1),100);
    theor_dist = exp(-(x - mean(eta)).^2/2/std_dev^2)/(std_dev*sqrt(2*pi));

    figure();
    hold on;
    grid on;
    plot(binCenter, obs_dist,'square');
    plot(x, theor_dist);
    xlabel('$\eta (m)$','Interpreter','latex');
    ylabel('$p(\eta)$','Interpreter','latex');
    legend("Observed Distribution","Theoretical Distribution")
    title('Comparison of Distributions (Wave elevations)')
    hold off
end

end

