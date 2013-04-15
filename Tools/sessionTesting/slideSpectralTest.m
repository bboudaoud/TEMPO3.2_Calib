function result = sessSpectralTest(filename, win_len, samp_rate, cutoff, max_content)
% sessSpectralTest Function to perform spectral content within range
% testing on a sliding window
%
% report = sessSpectralTest(filename, samp_rate, cutoff, percentage) writes 
% test results to cell-array report
%
% Output is a cell-array with the following fields:
% [Test Status (PASS or FAIL)] [Number of Failures (0  or 1)] [Failure 1]
%
% Parameters:
% filename: The data file to be tested
% win_len: The length of the sliding window for testing (in samples)
% samp_rate: The sampling rate of the session to be tested
% cutoff: The spectral cut-off frequency (in Hz)
% max_content: The maximum allowable spectral content above the threshold
% (out of band)
%
% Example:
% status = sessSpectralTest(105, 1, 128, [10, 10, 10, 10, 10, 10], [5, 5, 5, 5, 5, 5])
% Tests whether 95% of spectral content in each of the axes falls below 10Hz
% if not returns a FAIL code to the user
%
% 3/26/13
axis_label = {'X Acceleromter', 'Y Accelerometer', 'Z Accelerometer', 'X Gyro', 'Y Gyro', 'Z Gyro'};
fail_index = 0;
retstruct = struct('test_name', 'Sliding Window Spectral Density');
% Load session from disk
session = dataLoad(filename);
for win_start = [1:size(session.data,1)-win_len] 
    % Compute fft
    spectrum = abs(fft(session.data(win_start:win_start+win_len,:)));
    spectrum = spectrum(1:ceil(win_len/2), :);
    % Compute total spectral content
    total_content = sum(spectrum);
    % Compute the cut-off index and content below this index
    fc = cutoff*win_len/(2*samp_rate);
    highpass_content = sum(spectrum(ceil(fc):size(spectrum,1)));
    % Compute maginal content and compare
    spectral_frac = 100*(highpass_content./total_content);

    for i = [1:6]
        if(spectral_frac(i) > max_content(i))
            fail_index = fail_index + 1;
            fail = sprintf('%s spectral content out of range (%2.2f percent @ index %d)', axis_label{i}, spectral_frac(i), win_start);
            retstruct.fail_list{fail_index} = fail;
        end
    end
end
if(fail_index == 0)
    retstruct.result = 'PASS';
    retstruct.num_fail = 0;
else
    retstruct.result = 'FAIL';
    retstruct.num_fail = fail_index;
end

result = retstruct;