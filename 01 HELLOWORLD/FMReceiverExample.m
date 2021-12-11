%% FM Broadcast Receiver
% This example shows how to build an FM mono or stereo receiver using
% MATLAB(R) and Communications Toolbox(TM). You can either use
% captured signals, or receive signals in real time using the RTL-SDR Radio
% or ADALM-PLUTO Radio.

% Copyright 2013-2018 The MathWorks, Inc.

%% Required Hardware and Software
% To run this example using captured signals, you need the following
% software:
%
% * <matlab:web(['https://www.mathworks.com/products/communications/'],'-browser')
% Communications Toolbox(TM)>
%
% To receive signals in real time, you also need one of the following
% hardware:
%
% * RTL-SDR radio and the corresponding software
% <matlab:web(['https://www.mathworks.com/hardware-support/rtl-sdr.html'],'-browser')
% Communications Toolbox Support Package for RTL-SDR Radio>
%
% * ADALM-PLUTO radio and the corresponding software
% <matlab:web(['https://www.mathworks.com/hardware-support/adalm-pluto-radio.html'],'-browser')
% Communications Toolbox Support Package for ADALM-PLUTO Radio>
% 
% 
% For a full list of Communications Toolbox supported SDR platforms,
% refer to Supported Hardware section of
% <matlab:web(['https://www.mathworks.com/discovery/sdr.html'],'-browser')
% Software-Defined Radio (SDR)>.

%% Background
% FM broadcasting uses frequency modulation (FM) to provide high-fidelity
% sound transmission over broadcast radio channels. Pre-emphasis and
% de-emphasis filters are used to reduce the effect of noise on high audio
% frequencies. Stereo encoding enables simultaneous transmission of both
% left and right audio channels over the same FM channel [ <#7 1> ].

%% Run the Example
% Type <matlab:commandwindow;FMReceiverExample FMReceiverExample> in the
% MATLAB Command Window or click the link to run the example. You need to
% enter the following information when you run the example:
% 
% # Reception duration in seconds
% # Signal source (captured data, RTL-SDR radio or ADALM-PLUTO radio)
% # FM channel frequency
%
% The example plays the received audio over your computer's speakers.
%
% NOTE: This example utilizes a center frequency that is outside the
% default tuning range. Click <matlab:configurePlutoRadio('AD9364')
% configurePlutoRadio('AD9364')> to use your ADALM-PLUTO radio outside the qualified
% tuning range.
%
%% Receiver Structure
% The FM Broadcast Demodulator Baseband System object(TM) converts the
% input sampling rate of the 228 kHz to 45.6 kHz, the sampling rate for
% your host computer's audio device. According to the FM broadcast standard
% in the United States, the de-emphasis lowpass filter time constant is set
% to 75 microseconds. This example processes the received mono signals. The
% demodulator can also process stereo signals.
%
% To perform stereo decoding, the FM Broadcast Demodulator Baseband object
% uses a peaking filter which picks out the 19 kHz pilot tone from which
% the 38 kHz carrier is created. Using the resulting carrier signal, the FM
% Broadcast Demodulator Baseband block downconverts the L-R signal,
% centered at 38 kHz, to baseband. Afterwards, the L-R and L+R signals pass
% through a 75 microsecond de-emphasis filter . The FM Broadcast
% Demodulator Baseband block separates the L and R signals and converts
% them to the 45.6 kHz audio signal.

%% Example Code
% The receiver asks for user input and initializes variables. Then, it
% calls the signal source and FM broadcast receiver in a loop. The loop
% also keeps track of the radio time using the frame duration and lost
% samples reported by the signal source.
%
% The latency output of the signal source is an indication of when the
% samples were actually received and can be used to determine how close to
% real time the receiver is running. A latency value of 1 and a lost
% samples value of 0 indicates that the system is running in real time. A
% latency value of greater than one indicates that the receiver was not
% able to process the samples in real time. Latency is reported in terms of
% the number of frames. It can be between 1 and 128. If latency is greater
% than 128, then samples are lost.

% Request user input from the command-line for application parameters
userInput = helperFMUserInput;

% Calculate FM system parameters based on the user input
[fmRxParams,sigSrc] = helperFMConfig(userInput);

% Create FM broadcast receiver object and configure based on user input
fmBroadcastDemod = comm.FMBroadcastDemodulator(...
    'SampleRate', fmRxParams.FrontEndSampleRate, ...
    'FrequencyDeviation', fmRxParams.FrequencyDeviation, ...
    'FilterTimeConstant', fmRxParams.FilterTimeConstant, ...
    'AudioSampleRate', fmRxParams.AudioSampleRate, ...
    'Stereo', false);

% Create audio player
player = audioDeviceWriter('SampleRate',fmRxParams.AudioSampleRate);

% Initialize radio time
radioTime = 0;

% Main loop
while radioTime < userInput.Duration
  % Receive baseband samples (Signal Source)
  if fmRxParams.isSourceRadio
      if fmRxParams.isSourcePlutoSDR
          rcv = sigSrc();
          lost = 0;
          late = 1;
      else
          [rcv,~,lost,late] = sigSrc();
      end
  else
    rcv = sigSrc();
    lost = 0;
    late = 1;
  end
  
  % Demodulate FM broadcast signals and play the decoded audio
  audioSig = fmBroadcastDemod(rcv);
  player(audioSig);

  % Update radio time. If there were lost samples, add those too.
  radioTime = radioTime + fmRxParams.FrontEndFrameTime + ...
    double(lost)/fmRxParams.FrontEndSampleRate;
end

% Release the audio and the signal source
release(sigSrc)
release(fmBroadcastDemod)
release(player)

%% Further Exploration
% To further explore the example, you can vary the center frequency of the
% RTL-SDR radio or ADALM-PLUTO radio and listen to other radio stations.
%
% You can set the Stereo property of the FM demodulator object to true to
% process the signals in stereo fashion and compare the sound quality.
%
% You can explore following function for details of the system parameters:
%
% * <matlab:edit('helperFMConfig.m') helperFMConfig.m>
%
% You can further explore the FM signals using FMReceiverExampleApp user
% interface. This app allows you to select the signal source and change the
% center frequency of the RTL-SDR radio or ADALM-PLUTO radio. To launch the
% app, type <matlab:commandwindow;FMReceiverExampleApp
% FMReceiverExampleApp> in the MATLAB Command Window. This user interface
% is shown in the following figure
%
% <<FMReceiverExampleApp.png>>
%

%% Selected Bibliography 
% 
% # http://en.wikipedia.org/wiki/FM_broadcasting

displayEndOfDemoMessage(mfilename)
