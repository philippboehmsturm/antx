%% General timing constants
% dt is the time resolution (in seconds) of the generated hrf.
dt = .05;

%% Create response
% A canonical HRF response is created.
xBF.name = 'hrf time dispersion';
xBF.dt   = dt;
xBF      = spm_get_bf(xBF);

fh = figure;
ax = axes('parent', fh);
plot(ax,0:xBF.dt:(xBF.length-xBF.dt),xBF.bf)

%% FFT
NFFT = 2^nextpow2(size(xBF.bf,1)); % Next power of 2 from length of y
Y = fft(xBF.bf,NFFT)/size(xBF.bf,1);
f = 1/(2*dt)*linspace(0,1,NFFT/2+1);
% Plot single-sided amplitude spectrum.
fs = figure;
ax = axes('parent',fs);
plot(ax,f,2*abs(Y(1:NFFT/2+1))) 
title('Single-Sided Amplitude Spectrum of hrf(t)')
xlabel('Frequency (Hz)')
ylabel('|Y(f)|')