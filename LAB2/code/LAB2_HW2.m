clc;
clear;
close all;

%% Step 1: Generate triangular signal
N = 128;
x = [1:64, 63:-1:0];

%% Step 2: Set SNR
SNR_dB = 15;

signal_power = mean(x.^2);
noise_power = signal_power / (10^(SNR_dB/10));

%% Step 3: Generate 100 noisy signals and check their SNR
num_signals = 25;

x_noisy_all = zeros(num_signals, N);
actual_SNR = zeros(1, num_signals);

for k = 1:num_signals

    % Generate Gaussian noise
    noise = sqrt(noise_power) * randn(1, N);

    % Add noise to original signal
    x_noisy_all(k, :) = x + noise;

    % Calculate actual SNR
    actual_SNR(k) = 10*log10(sum(x.^2) / sum(noise.^2));

    % Print the SNR of each noisy signal
    fprintf('Signal %3d: Actual SNR = %.2f dB\n', ...
        k, actual_SNR(k));
end

% Print the average SNR of 100 noisy signals
fprintf('\nAverage SNR = %.2f dB\n', mean(actual_SNR));

%% Step 4: Test M = 3 to 10
M_values = 1:15;
average_MSE = zeros(size(M_values));

center = N/2 + 1;

for m_index = 1:length(M_values)

    M = M_values(m_index);
    MSE = zeros(1, num_signals);

    % Create frequency-domain window
    W = zeros(1, N);
    reserved_index = center-M:center+M;
    W(reserved_index) = 1;

    for k = 1:num_signals

        x_noisy = x_noisy_all(k, :);

        % 128-point DFT
        X_noisy_shift = fftshift(fft(x_noisy, N));

        % Frequency-domain filtering
        X_filtered_shift = X_noisy_shift .* W;

        % Convert back to time domain
        x_recovered = real(ifft(ifftshift(X_filtered_shift)));

        % Calculate MSE
        MSE(k) = mean((x - x_recovered).^2);
    end

    % Average MSE of 100 noisy signals
    average_MSE(m_index) = mean(MSE);
end

%% Step 5: Plot average MSE
figure;
plot(M_values, average_MSE, '-o', ...
    'LineWidth', 1.5, 'MarkerSize', 7);

grid on;
xlabel('M');
ylabel('Average MSE');
title('Average MSE for Different M Values');

%% Step 6: Find the optimum M
[min_MSE, min_index] = min(average_MSE);
optimal_M = M_values(min_index);

fprintf('Optimal M = %d\n', optimal_M);
fprintf('Minimum average MSE = %.4f\n', min_MSE);
