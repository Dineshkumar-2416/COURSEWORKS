%get heart rate
hr = 72;
u = 30/hr;
x = 0.01:0.01:5;
%p wave
p_amp = 0.25;p_dur = 0.09; p_int = 0.16;
p_wave = sinusoid(x,p_amp,p_dur,-p_int,u);
%q wave
q_amp = 0.08; q_dur = 0.066; q_int = 0.166;
q_wave = triangular(x,q_amp,q_dur,-q_int,u);
%qrs wave
qrs_amp = 1.6; qrs_dur = 0.11; qrs_int = 0;
qrs_wave = triangular(x,qrs_amp,qrs_dur,qrs_int,u);
%s wave
s_amp = 0.25; s_dur = 0.066; s_int = 0.09;
s_wave = triangular(x,s_amp,s_dur,s_int,u);
%t_wave
t_amp = 0.35; t_dur = 0.142; t_int = 0.245;
t_wave = sinusoid(x,t_amp,t_dur,t_int,u);
%u wave
u_amp = 0.035; u_dur = 0.0476; u_int = 0.433;
u_wave = sinusoid(x,u_amp,u_dur,u_int,u);
plot(p_wave-q_wave+qrs_wave-s_wave+t_wave+u_wave);
xlabel('Time(s)');ylabel('Amplitude (mV)');
title("Simulated ECG Waveform");
function y = triangular(x,amp,dur,int,l)
a = amp;
b = (2*l)/dur;
a0 = a/b;
N = 200;
x = x-int;
y = a0/2 + zeros(size(x));
an = zeros(1,N);
for i = 1:N
    y1 = 2*a*b;
    y2 = (i*pi)^2;
    y3 = cos(i*pi/b);
    an(i) = (y1/y2)*(1-y3);
end
for j = 1:N
    y = y + an(j)*cos(j*pi*x/l);
end
end
function y = sinusoid(x,amp,dur,int,l)
a = amp;
b = (2*l)/dur;
a0 = 4*a/(pi*b);
N = 200;
x = x - int;
an = zeros(1,N);
for k = 1:N
    x1 = 4*a*b*cos(k*pi/b);
    x2 = pi*(b-2*k)*(b+2*k);
    an(k) = x1/x2;
end
y = a0/2 + zeros(size(x));
for w = 1:N
    y = y + an(w)*cos(w*pi*x/l);
end
end