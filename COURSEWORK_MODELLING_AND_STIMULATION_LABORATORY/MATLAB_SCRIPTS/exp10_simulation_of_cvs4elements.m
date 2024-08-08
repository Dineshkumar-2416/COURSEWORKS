Fs = 100;
Ts=20;
N=10; 
l = N*Fs;
t=0:1/Fs:(l-1)/Fs;
I=zeros(l,1);
for tx = 1:N
 for ix= 1: Fs
  if(ix<=Ts)
  I((Fs*(tx-1))+ix) = sin(pi*ix/Ts);
  end
 end
end
I=1500*(I.^2);
D=tf([1.512 20.1 252],[37.8 534 400]);
t1=1:1:336;
response1=lsim(D,I,t);
figure, subplot(211);
plot(t,I);
title('Input Blood Flow');
xlabel('Time(s)')
ylabel('Volume(mL)')
subplot(212)
plot(t,response1)
title('Output Arterial Blood Pressure')
xlabel('Time(s)')
ylabel('Pressure (mmHg)')
figure
plot(t(5*Fs:6*Fs),response1(5*Fs:6*Fs))
title('Output Arterial Blood Pressure')
xlabel('Time(s)')
ylabel('Pressure (mmHg)')
grid on