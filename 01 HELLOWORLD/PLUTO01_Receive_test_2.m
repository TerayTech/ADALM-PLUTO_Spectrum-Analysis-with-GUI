%disp(['Capture signal and observe the frequency offset' newline])
receivedSig = rx();
s11 = real(receivedSig);s12 = imag(receivedSig);
plot(s11);hold on;plot(s12);hold off;
axis([1,1000,-0.2,0.2]);

% Find the tone that corresponds to the 80 kHz transmitted tone
y = fftshift(abs(fft(receivedSig)));
[~, idx] = findpeaks(y,'MinPeakProminence',max(0.5*y));
fReceived = (max(idx)-numSamples/2-1)/numSamples*sampleRate;
% Plot the spectrum
sa = dsp.SpectrumAnalyzer('SampleRate', sampleRate, 'SpectralAverages', 4,...
    'SpectrumType','Power','ChannelNames',{'Power spectrum of the input'},'YLimits',[-120 40],'ShowLegend',true);

sa.CursorMeasurements.Enable = true;
sa.ChannelMeasurements.Enable = true;
sa.PeakFinder.Enable = true;
sa.DistortionMeasurements.Enable = true;

sa.Title = sprintf('Tone Expected at 80 kHz, Actually Received at %.3f kHz', ...
 fReceived/1000);
receivedSig = reshape(receivedSig, [], 16); % Reshape into 16 columns

data = [];
for i = 1:size(receivedSig, 2)
 sa(receivedSig(:,i));
 if sa.isNewDataReady
        data = [data;getMeasurementsData(sa)];
     end
end

%data = getMeasurementsData(sa);
peakvalues = data.PeakFinder(end).Value; 
disp(peakvalues);
