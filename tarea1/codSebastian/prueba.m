clc; clear all; close all;

Fs1 = 1000;
t1 = 0:1/Fs1:100;
x1 = sin(2*pi*1000*t1);
x2 = sin(2*pi*1500*t1);
x3 = sin(2*pi*2000*t1);
x_ch1 = 0.3*x1+0.2*x2+0.3*x3;
x_ch2 = 0.1*x1+0.3*x2+0.4*x3;
x = vertcat(x_ch1, x_ch1);

fft_Signal1 = fft(x(1,:));
z1 = fftshift(fft_Signal1);
fft_mag1 = abs(z1);
fft_phase1 = angle(z1);

fft_Signal2 = fft(x(2,:));
z2 = fftshift(fft_Signal2);
fft_mag2 = abs(z2);
fft_phase2 = angle(z2);

N = length(x);
%Fbins = ((0:1/N: 1-1/N)*Fs1).';
ly = length(x);
Fbins =(-ly/2:ly/2-1)/ly*Fs1;



subplot(1,3,1);
plot(t1, x(1,:), 'r');
hold on
plot(t1, x(2,:), 'b');
hold off
title('Signal');
subplot(1,3,2);
plot(Fbins, fft_mag1, 'r');
hold on
plot(Fbins, fft_mag2, 'b');
hold off
title('FFT - Mag');
subplot(1,3,3);
plot(Fbins, fft_phase1, 'r');
hold on
plot(Fbins, fft_phase2, 'b');
hold off
title('FFT - Mag');

audiowrite('pruebaSenos.wav',x',Fs1)