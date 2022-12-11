function [heights, timeperiods, index] = upcrossing(eta,t)
%GET_WAVEHTS Summary of this function goes here
%   Detailed explanation goes here

heights = [];
timeperiods = [];
index = [];

for i=1:numel(eta)-1
    if eta(i+1) > 0 && eta(i) < 0
        index(end+1) = i;
    end
end

for j = 1:numel(index)-1
    elevation = eta(index(j)+1:index(j+1));
    heights(end+1) = max(elevation) - min(elevation);
    timeperiods(end+1) = t(index(j+1)) - t(index(j)+1);
end
heights = heights';
timeperiods = timeperiods';
index = index';
end

