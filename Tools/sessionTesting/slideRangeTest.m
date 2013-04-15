function result = slideRangeTest(filename, win_len, min_val, max_val)
% slideSumTest Function to perform sliding sum in range testing on a given
% TEMPO data seession
%
% report = slideSumTest(filename, win_len, cutoff, percentage) writes 
% test results to cell-array report
%
% Output is a cell-array with the following fields:
% [Test Status (PASS or FAIL)] [Number of Failures (0  or 1)] [Failure 1]
%
% Parameters:
% filename: The data file to be tested
% win_len: The length of the sliding window for testing (in samples)
% min_val: An array of minimum values for the sum, over a window, of each 
% stream in the file
% max_val: An array of maximum values for the sum, over a window, of each
% stream in the file
%
% Example:
% status = slideRangeTest('TEMPO3.2F-0105_s00001.dat.gz', 10, [100, 100, 100, 100, 100, 100], [40000, 40000, 40000, 40000, 40000, 40000])
% Tests whether the sum of 10 sample windows falls between 100 and 40,000
% for each of the 6 sensor axis, reports if this is not the case
%
% 4/9/13
axis_label = {'X Acceleromter', 'Y Accelerometer', 'Z Accelerometer', 'X Gyro', 'Y Gyro', 'Z Gyro'};
fail_index = 0;
retstruct = struct('test_name', 'Sliding Sum in Range');
% Load the session
session = dataLoad(filename);
for win_start = [1:size(session.data, 1)-win_len]
    sum_val = sum(session.data(win_start:win_start+win_len,:)); % Sum the window
    for i = [1:6]
        if (sum_val(i) < min_val(i))
            fail_index = fail_index + 1;
            fail = sprintf('%s sum below threshold (%d @ index %d)', axis_label{i}, sum_val(i), win_start);
            retstruct.fail_list{fail_index} = fail;
        elseif (sum_val(i) > max_val(i))
            fail_index = fail_index + 1;
            fail = sprintf('%s sum above threshold (%d @ index %d)', axis_label{i}, sum_val(i), win_start);
            retstruct.fail_list{fail_index} = fail;
        end
    end
end
if (fail_index == 0)
    retstruct.result = 'PASS';
    retstruct.num_fail = 0;
else
    retstruct.result = 'FAIL';
    retstruct.num_fail = fail_index;
end

result = retstruct;
    