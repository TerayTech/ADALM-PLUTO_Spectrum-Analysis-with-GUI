% Set up parameters and signals
sampleRate = 1e6;
centerFreq = 1e9;

s = exp(1j*2*pi*1e3*[0:10000-1]'/sampleRate); % 20 kHz
s = 0.2*s/max(abs(s));% Scale signal to avoid clipping in the time domain

% Set up the transmitter
% Use the default value of 0 for FrequencyCorrection, which corresponds to
% the factory-calibrated condition
tx = sdrtx('Pluto', 'RadioID', 'usb:0', 'CenterFrequency', centerFreq, ...
 'BasebandSampleRate', sampleRate, 'Gain', 0, ...
 'ShowAdvancedProperties', true);

% Use the info method to show the actual values of various hardware-related
% properties
txRadioInfo = info(tx);
% Send signals
disp('Send 3 tones at 20, 40, and 80 kHz');
transmitRepeat(tx, s);

% Set up the receiver
% Use the default value of 0 for FrequencyCorrection, which corresponds to
% the factory-calibrated condition
numSamples = 1024*1024;
rx = sdrrx('Pluto', 'RadioID', 'usb:0', 'CenterFrequency', centerFreq, ...
 'BasebandSampleRate', sampleRate, 'SamplesPerFrame', numSamples, ...
 'OutputDataType', 'double', 'ShowAdvancedProperties', true);

% Use the info method to show the actual values of various hardware-related
% properties
rxRadioInfo = info(rx);
