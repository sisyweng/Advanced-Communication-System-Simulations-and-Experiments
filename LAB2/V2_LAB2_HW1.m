clc;
clear;
close all;

%% 基本參數
f0 = 1e6;       % 原始訊號頻率：1 MHz
Fs1 = 4e6;      % 第一個取樣頻率：4 MHz
Fs2 = 1.5e6;    % 第二個取樣頻率：1.5 MHz
N = 256;        % DFT 大小及取樣點數



%% 情況一：Fs = 4 MHz

% 建立時間軸
t1 = (0:N-1)/Fs1;

% 產生離散正弦訊號
x1 = sin(2*pi*f0*t1);

% 畫原始訊號
figure(1);

plot(t1*1e6, x1);
title('Original Signal, Fs = 4 MHz');
xlabel('Time (\mus)');
ylabel('Amplitude');

% 直接使用 FFT
y1 = abs(fftshift(fft(x1, N)));

% 建立頻率橫軸
f_axis1 = (0:N-1)*(Fs1/N);

% 畫頻譜
figure(2);
plot(f_axis1/1e6, y1);
title('DFT Spectrum, Fs = 4 MHz');
xlabel('Frequency (MHz)');
ylabel('Magnitude');

%% 情況二：Fs = 1.5 MHz

% 建立時間軸
t2 = (0:N-1)/Fs2;

% 產生離散正弦訊號
x2 = sin(2*pi*f0*t2);

% 畫原始訊號
figure(3);
plot(t2*1e6, x2);
title('Original Signal, Fs = 1.5 MHz');
xlabel('Time (\mus)');
ylabel('Amplitude');

% 直接使用 FFT
y2 = abs(fftshift(fft(x2, N)));

% 建立頻率橫軸
f_axis2 = (0:N-1)*(Fs2/N);

% 畫頻譜
figure(4);
plot(f_axis2/1e6, y2);
title('DFT Spectrum, Fs = 1.5 MHz');
xlabel('Frequency (MHz)');
ylabel('Magnitude');
