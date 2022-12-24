function [heights, timeperiods, index] = get_wvhts(eta,t, varargin)
%GET_WAVEHTS calculates waveheights and corresponding timeperiods of the
%given irregular wave
%   [heights, timeperiods, index] = get_wvhts(eta,t)
% HEIGHTS       The waveheight data for the irregular wave
% TIMEPERIODS   Stores the corresponding timeperiod for the waveheight
% INDEX         Stores the index of datapoints where upcrossing or down crossing
% occurs
%
% [heights, timeperiods, index] = get_wvhts(eta,t,'PARAM',val) specifies optional parameter name/value pairs:
%        'Crossing'      - Either 'upcrossing' or 'downcrossing' can be specified
%  

p = inputParser;
paramName = 'Crossing';
defaultVal = 'upcrossing';
addParameter(p,paramName,defaultVal)

parse(p, varargin{:});
crossing = p.Results.Crossing;

heights = [];
timeperiods = [];
index = [];

% perform zero upcrossing
if crossing == 'upcrossing'
    for i=1:numel(eta)-1
        if eta(i+1) > 0 && eta(i) <= 0
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

% perform zero downcrossing
elseif crossing == 'downcrossing'
    for i=1:numel(eta)-1
        if eta(i+1) < 0 && eta(i) >= 0
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

end

