function [ fundamental, zcr_avg, sum_short_avg] = Charac_features( my2,fs )
% Detailed explanation goes here
myrecording = my2(:,1);%Taking only one sample of the test
%plot(myrecording);
length_samp=length(myrecording);%Taking the length of the recording
%Filter Low Pass
d=fdesign.lowpass('N,Fc',100,1000,fs);%Designing the lowpass fiter with cutoff freq 1000
%designmethods(d);
Hd = design(d);
%fvtool(Hd);
[h,t] = impz(Hd);%Finding the impulse response of the filter
myrecording=filter(Hd,myrecording);%Filtering the input
%Rectangular Windowing
num_of_samples=fs*30*0.001;% 30 milisecond of the frame
num_over=fs*10*0.001;% 10 milisecond of the overlapping
num_samp=num_of_samples-num_over;%Number of new samples in each frame
n=ceil((length_samp-num_of_samples)/num_samp);%Find the number of iterations
for i=1:n % 30 milisecond of the frame and 10 milisecond of the overlapping
 if i==1
 samp(:,1)=myrecording(1:num_of_samples);
 else
 samp(:,i)=myrecording(num_samp*(i1)+1:num_samp*(i-1)+num_of_samples);
 end
end
short_energy=zeros(1,n);
zcr_sum=zeros(1,n);
for i=1:n
 auto(:,i)=xcorr(samp(:,i));
 [aut, loc]=findpeaks(auto(:,i));%Finding the peaks
 sum1(i)=mean(diff(loc));%Finding the difference in the location of peaks
 dummy=0;
 short_en=transpose(samp(:,i).*samp(:,i));
 for j=1:num_of_samples
 dummy=dummy+short_en(j);%Adding all the energy in the frame
 end
 short_energy(i)=dummy;
 zcr_dummy=0;
 zcr_sample=samp(:,i);
 for j=2:num_of_samples
 zcr_dummy=zcr_dummy+abs(sign(zcr_sample(j))-sign(zcr_sample(j-1)));
 %Counting number of zero crossing
 end
 zcr_sum(i)=zcr_dummy;
end
zcr_avg=mean((zcr_sum/2));%Taking the average zero
crossing frequency of all the frames
sum_short_avg=mean(short_energy);%Taking the average short energy of all the frames
period=max(sum1);%Finding the period
fundamental=fs/period;%Finding the fundamental
frequency
end
