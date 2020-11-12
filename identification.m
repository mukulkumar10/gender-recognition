% Program:
clc
clear all
close all
%Feature Classification
%All the fundamental values are for adult male
fundamental_freq_level=160;%Manually fixing the value of the fundamental freq
zero_crossing_level=20;%Manually fixing the value of the zero crossing value
short_energy_level=4.0;%Manually fixing the value of the Short energy value
%Reading a file and getting the fundamental,zero
crossing, short energy
%values
recObj = audiorecorder(12500,8,1);
disp('start speaking')
recordblocking(recObj, 4);
disp('End of recording')
myRecording = getaudiodata(recObj);
audiowrite('output.wav', myRecording,12500);
[y,sample_rate]= audioread('output.wav');
Fs = sample_rate;
% Sampling Frequency (Hz)
Fn = Fs/2;
% Nyquist Frequency (Hz)
Wp = 1000/Fn;
% Passband Frequency (Normalised)
Ws = 1010/Fn;
% Stopband Frequency (Normalised)
Rp = 1;
% Passband Ripple (dB)
Rs = 150;
% Stopband Ripple (dB)
[n,Ws] = cheb2ord(Wp,Ws,Rp,Rs);
% Filter Order
[z,p,k] = cheby2(n+5,Rs,Ws,'low');
% Filter Design
[soslp,glp] = zp2sos(z,p,k);
% Convert To Second-Order-Section For Stability
% Filter Bode Plot
filtered_sound = filtfilt(soslp, glp,y);
audiowrite('output1.wav', filtered_sound,sample_rate);
[my2,fs] = audioread('output1.wav');
sound(my2,fs);
figure;plot(my2);title('Test Signal');
xlabel('Index');ylabel('Amplitude');
[freq,zero_cross,short_ene]=Charac_features(my2,fs);
%Giving weights and finding a number for a particular obseravation
Speech_Score=0.25*(freq/fundamental_freq_level)+(zero_cross/zero_crossing_level)*0.35;
Speech_Score=Speech_Score+(0.4*short_ene/short_energy_level)
if Speech_Score>1 %if value greater than 1 for that particular observation
 ans='Female'
else
 ans='Male'
end 