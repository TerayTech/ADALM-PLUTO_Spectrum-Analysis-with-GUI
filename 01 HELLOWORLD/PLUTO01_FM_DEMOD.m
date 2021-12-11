bbr = comm.BasebandFileReader('FMRecording.bb');
bbr.SamplesPerFrame = 4400;
fmbDemod = comm.FMBroadcastDemodulator('AudioSampleRate',48e3, ...
 'SampleRate',bbr.Metadata.BasebandSampleRate,'PlaySound',true);
while ~isDone(bbr)
 fmbDemod(bbr());
end