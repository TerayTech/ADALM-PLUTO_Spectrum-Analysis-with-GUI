% Set up parameters and signals
sampleRate = 200e3;
centerFreq = 1e9;
fRef = 50e3;
s1 = exp(1j*2*pi*10e3*[0:10000-1]'/sampleRate); % 20 kHz
s2 = exp(1j*2*pi*30e3*[0:10000-1]'/sampleRate); % 40 kHz
s3 = exp(1j*2*pi*fRef*[0:10000-1]'/sampleRate); % 80 kHz
s = s1 + s2 + s3;
s = 0.6*s/max(abs(s)); % Scale signal to avoid clipping in the time domain

% Set up the transmitter
% Use the default value of 0 for FrequencyCorrection, which corresponds to
% the factory-calibrated condition
tx = sdrtx('Pluto', 'RadioID', 'usb:0', 'CenterFrequency', centerFreq, ...
 'BasebandSampleRate', sampleRate, 'Gain', 0, ...
 'ShowAdvancedProperties', true);
% Use the info method to show the actual values of various hardware-related
% properties
txRadioInfo = info(tx)
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
rxRadioInfo = info(rx)  


