function wt=lanc(numwt,haf)
% NAME                                               ;
%    function wt=lanc(nuwwt,haf)                     ;
% PURPOSE                                            ;
%     generates a numwt+1+numwt lanczos cosine       ;
%     low pass filter with -6dB (1/4 power, 1/2      ;
%     amplitude) point at haf                        ;
% INPUT                                              ;
%    numwt    number of points                       ;
%    haf      frequency (in (cpi) of -6dB point      ;
%             cpi is cycles per interval. For hourly ;
%             data cpi is cph                        ;
%                                                    ;
% 1 Dec 1994 Woody Lee TAMU/GERG based on FORTRAN    ;
%            code of Steve Worley                    ;

% Preliminaries;

summ  = 0.0;
numwt = numwt+1;
wt    = (1:numwt)*0;
rcp   = 1./numwt;
haf2  = haf+haf;

% Estimate filter weights;

ii = 1:numwt;
wt = 0.5*(1.0+cos(pi*(ii-1)*rcp));
ii = 2:numwt;
xx = pi*haf2*(ii-1);

wt(2:numwt) = wt(2:numwt).*sin(xx)./xx;

summ  = sum(wt(2:numwt));
xx    = sum(wt)+summ;
wt    = wt./xx;
wt    = [fliplr(wt),wt(2:numwt)];
