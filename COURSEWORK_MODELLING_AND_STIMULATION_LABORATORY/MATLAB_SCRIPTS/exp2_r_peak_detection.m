






























% Load ECG data
ecg_data = load("D:\FINAL_SEM2_SIMULATION_LAB\Scripts\100m.mat");
og = ecg_data.val(1, 1:4000) ./ 200; % Use the first 4000 samples and normalize
figure;
plot(og);
title('Raw ECG Data');
xlabel('Sample');
ylabel('Amplitude');

% Define sampling frequency
fs = 360;

% Bandpass filter parameters
fl = 5; % Low cutoff frequency in Hz
fh = 20; % High cutoff frequency in Hz

% Design the bandpass filter
[b, a] = cheby1(4, 0.0001, [fl fh]/(fs/2), 'bandpass'); % Divide by (fs/2) for normalized frequency

% Apply the filter to the ECG signal
filtered_ecg = filtfilt(b, a, og);
figure;
plot(filtered_ecg);
title('Filtered ECG Data');
xlabel('Sample');
ylabel('Amplitude');

% Differentiation
different = diff(filtered_ecg);
figure;
plot(different);
title('Differentiated ECG');
xlabel('Sample');
ylabel('Amplitude');

% Amplitude normalization
norm = different / max(abs(different));
figure;
plot(norm);
title('Normalized Amplitude');
xlabel('Sample');
ylabel('Amplitude');

% Shannon energy envelope
norm_squared = norm.^2;
log_norm_squared = log(norm_squared);
shannon = norm_squared .* log_norm_squared * (-1);
figure;
plot(shannon);
title('Shannon Energy Envelope');
xlabel('Sample');
ylabel('Energy');

% Moving average
ma1 = (1/65) * ones(65, 1);
moving_avg = filtfilt(ma1, 1, shannon);
figure;
plot(moving_avg);
title('First Moving Average');
xlabel('Sample');
ylabel('Amplitude');

% Second differentiation
s2 = diff(moving_avg);
figure;
plot(s2);
title('First Order After Moving Average');
xlabel('Sample');
ylabel('Amplitude');

% Squaring
osqr = s2.^2;
figure;
plot(osqr);
title('Squaring');
xlabel('Sample');
ylabel('Amplitude');

% Second moving average
q = (1/85) * ones(85, 1);
ma2 = filtfilt(q, 1, osqr);
figure;
plot(ma2);
title('Second Moving Average');
xlabel('Sample');
ylabel('Amplitude');

% Find peaks in the second moving average
[pks, locs] = findpeaks(ma2);

% Preallocate the output array
o = zeros(size(locs));

% Find the true R peak in the neighborhood (25 samples) of detected points
for v = 1:numel(locs)
    j = 1;
    search_start = max(locs(v) - 25, 1);
    search_end = min(locs(v) + 25, length(og));
    t = zeros(search_end - search_start + 1, 1); % Preallocate t
    for i = search_start:search_end
        t(j) = og(i);
        j = j + 1;
    end
    [mag, pos] = max(t);
    o(v) = (pos - 1) + search_start;
end

% Display the final true position of R-peaks
disp('Final true position of R-peaks:')
disp(o);

% Plot ECG R peak locations
g = 1:length(og);

figure;
plot(og);
hold on;
stem(g(o), og(o), 'r', 'filled');
title('ECG True R Peak Locations');
xlabel('Sample');
ylabel('Amplitude');
legend('ECG Signal', 'R-Peaks');
hold off;
