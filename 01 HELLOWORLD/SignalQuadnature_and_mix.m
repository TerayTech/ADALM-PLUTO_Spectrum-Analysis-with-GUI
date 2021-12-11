% Set up parameters and signals
sampleRate = 1e6;
centerFreq = 1e9;
fRef = 50e3;
s1 = exp(1j*2*pi*10e3*[0:10000-1]'/sampleRate); % 20 kHz
s2 = exp(1j*2*pi*30e3*[0:10000-1]'/sampleRate); % 40 kHz
s3 = exp(1j*2*pi*fRef*[0:10000-1]'/sampleRate); % 80 kHz
s = s1 + s2 + s3;
s = 0.6*s/max(abs(s)); % Scale signal to avoid clipping in the time domain
%subplot(311);plot(s1);
%subplot(312);plot(s2);
%subplot(313);plot(s3);
%xlabel('Re(s1)');ylabel('Im(s1)');
s11 = real(s1);s12 = imag(s1);
plot(s11);hold on;plot(s12);hold off;
axis([1,101,-1,1]);
y = fftshift(abs(fft(s)));
%plot(y);
