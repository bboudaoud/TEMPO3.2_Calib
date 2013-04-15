function result = slideMeanTest(filename, win_len, expected_mean, range)
% slideMeanTest Function to perform mean-value-within-range testing on a
% sliding window
%
% report = sessMeanTest(filename, mean, range) writes test results to
% cell-array report
%
% Output is a cell-array with the following fields:
% [Test Status (PASS or FAIL)] [Number of Failures] [Failure 1] ... [Failure N]
%
% Parameters:
% filename: The data file to be tested
% win_len: The length of the sliding window for testing (in samples)
% expected_mean: The vector of expected means for each sensor in the given
% data session
% range: The acceptable range (difference) between input and actual
% computed mean for each sensor in the given data session
%
% Example:
% status = sessMeanTest(105, 1, 1, [2048, 2048, 2048, 1800, 1800, 1800], [200, 200, 200, 200, 200, 200])
% Tests whether the computed session mean is within the provided range of
% the specified mean for each sesnsor in the data session.
%
% 3/26/13
axis_label = {'X Acceleromter', 'Y Accelerometer', 'Z Accelerometer', 'X Gyro', 'Y Gyro', 'Z Gyro'};
fail_index = 0;
retstruct = struct('test_name', 'Sliding Window Mean Thresholding');
%Load the session from disk
session = dataLoad(filename);
for win_start = [1:size(session.data,1)-win_len]
    %Determine the mean
    meanval = mean(session.data(win_start:win_start+win_len,:));
    for i = [1:6]
        if(abs(meanval(i) - expected_mean(i)) > range(i))
            fail_index = fail_index + 1;
            fail = sprintf('%s mean out of range (%2.2f @ index %d)', axis_label{i}, meanval(i), win_start);
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

