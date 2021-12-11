deviceName = 'Pluto';
samplerate = 528e3;
fmStationFrequency = 88.9e6; % Adjust to select an FM station nearby
rx = sdrrx(deviceName,'BasebandSampleRate',samplerate, ...
 'CenterFrequency',fmStationFrequency,'OutputDataType','double');

capture(rx,5,'Seconds','Filename','FMRecording.bb');
