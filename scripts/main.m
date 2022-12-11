
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

% calculating wave heights using upcrossing method
[wave_hts, timeperiods, id] = upcrossing(eta,time);

