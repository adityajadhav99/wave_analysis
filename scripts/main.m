
clear all; close all; clc;

set(0,'DefaultAxesFontName','Times New Roman')
set(0,'DefaultAxesFontSize',14)
set(0,'DefaultLineLineWidth',1.5)

load ../data/elevation.csv

% wave elevation in meters
eta = elevation(:,2)/100;
time = linspace(1, 1800, 2304);

figure();
hold on;
grid on;
plot(time, eta);
xlabel('time');
ylabel('$\eta (m)$','Interpreter','latex');
title('wave elevation');
% saveas(gcf,'../plots/wave_elevation.png')
hold off;

% demeaning elevation
eta = eta - mean(eta);
std_dev = std(eta);
min_eta = min(eta);
max_eta = max(eta);

Hs = 4*std_dev;

bin_width = 0.02;
nbins = round((max_eta - min_eta)/bin_width);

figure;
h = histogram(eta,nbins);
xlabel('$\eta$','Interpreter','latex');
ylabel('number of data points');
title('Histogram Plot');

% compare theoretical vs observed pdf
obs_dist = h.Values/sum(h.Values)/bin_width;
x = linspace(-0.2,0.2,100);
theor_dist = exp(-(x - mean(eta)).^2/2/std_dev^2)/(std_dev*sqrt(2*pi));

figure();
hold on;
grid on;
plot(h.BinEdges(1:end-1), obs_dist,'square');
plot(x, theor_dist);
xlabel('$\eta (m)$','Interpreter','latex');
ylabel('$p(\eta)$','Interpreter','latex');
legend("Observed Distribution","Theoretical Distribution")
title('Comparison of Distributions (Wave elevations)')
hold off

%% wave height analysis

% calculating wave heights using upcrossing method
[wave_hts, timeperiods, id] = upcrossing(eta,time);

sorted_wvhts = sort(wave_hts,'descend');

% first 1/n waves to calculate the significant wave height
n = 10;
Hs = mean(sorted_wvhts(1:round(numel(wave_hts)/n)));

bin_width = 0.02;
nbins = round((max(wave_hts) - min(wave_hts))/bin_width);

figure;
h_waveht = histogram(wave_hts,nbins);
xlabel('$H (m)$','Interpreter','latex');
ylabel('number of data points');
title('Wave Height Histogram Plot');

% compare theoretical vs observed pdf
obs_ht_dist = h_waveht.Values/sum(h_waveht.Values)/bin_width;
x = linspace(0,0.3,100);
Hrms = rms(wave_hts);
rayleigh_dist = (2*x/(Hrms^2)).*exp(-(x.^2)/Hrms^2);

figure();
hold on;
grid on;
plot(h_waveht.BinEdges(1:end-1), obs_ht_dist,'square');
plot(x, rayleigh_dist);
xlabel('$H (m)$','Interpreter','latex');
ylabel('$p(H)$','Interpreter','latex');
legend("Observed Distribution","Rayleigh Distribution")
title('Comparison of Distributions (Wave Heights)')
hold off
