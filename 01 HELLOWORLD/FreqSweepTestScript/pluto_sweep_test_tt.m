%% SETUP:
% Parameters for frequency scan:
cfstart=70e6; % Start frequency
cfstop=6000e6; % Stop frequency
nstep=594; % Number of frequency steps
cfreq=linspace(cfstart,cfstop,nstep);
cal=zeros(nstep,1); % Array for calibration amplitudes
amp=zeros(nstep,1); % Array for DUT amplitudes
rl=zeros(nstep,1); % Array for DUT return loss

tx = comm.SDRTxPluto; % SDRTxPluto system object for transmitter
tx.CenterFrequency=cfreq(1); % Tuner frequency in Hz
tx.Gain=-30; % Transmitter gain in dB (-89.75 to 0 dB)
tx.BasebandSampleRate=1e5; % DAC sampling rate in Hz
% Generate the 5kHz test tone:
sw = dsp.SineWave;
sw.Amplitude = 1;
sw.Frequency = 5e3;
sw.ComplexOutput = true;
sw.SampleRate = tx.BasebandSampleRate;
sw.SamplesPerFrame = 5000;
txdata = conj(sw()); % Use conj() to generate the lower sideband

rx = comm.SDRRxPluto; % SDRRxPluto system object for receiver
rx.CenterFrequency=tx.CenterFrequency; % Tuner frequency in Hz
rx.GainSource='Manual'; % Disables the AGC
rx.Gain=50; % Tuner gain in dB (-4 to 71 dB)
rx.BasebandSampleRate=tx.BasebandSampleRate; % ADC sampling rate in Hz
rx.SamplesPerFrame=1000; % Output data frame size
rx.OutputDataType='int16'; % Output data type
ndec=4; % Decimation factor

%% SCANS
% Check that the PlutoSDR is active:
if ~isempty(findPlutoRadio)
fmin=0;
df=rx.BasebandSampleRate/rx.SamplesPerFrame;
fmax=rx.BasebandSampleRate/ndec-df;
freq=linspace(fmin,fmax,rx.SamplesPerFrame/ndec)/1000; % freq in kHz
index=sw.Frequency/df+1;

%% CALIBRATION LOOP:
%
%input('Remove DUT - then press any key')
for n = 1: nstep
txfreq=cfreq(n);
tx.CenterFrequency=txfreq; % Tuner frequency in Hz
%tx.transmitRepeat(txdata); % Repeated transmission
rx.CenterFrequency=tx.CenterFrequency; % Tuner frequency in Hz
for m = 1:10 % Read multiple times to clear the Rx buffer
data = rx(); % Fetch a frame from the Pluto SDR
end
ddata=decimate(double(data),ndec);
spec=ifft(ddata); % Signal amplitude at 5kHz is in spec(51)
cal(n)=abs(spec(index));
figure(1);
subplot(311);
plot(1e-6*cfreq,cal);
xlabel('Frequency / MHz');
%xlim([70 6000]);
ylabel('Amplitude');
title('TerayTech ADALM-PLUTO Spectrum Scan');
subplot(312);
plot(data);
xlabel('Re(Z)');
ylabel('Im(Z)');
title('Raw Data Quadrature');
subplot(313);
plot(real(data));hold on;plot(imag(data));hold off;
drawnow;
end

end