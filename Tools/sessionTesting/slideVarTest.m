function result = slideVarTest(filename, win_len, expected_var, range)
% sessVarTest Function to perform variance-within-range test on a sliding
% window
%
% report = sessVarTest(filename, win_len, var, range) writes test results to
% cell-array report
%
% Output is a cell-array with the following fields:
% [Test Status (PASS or FAIL)] [Number of Failures] [Failure 1] ... [Failure N]
%
% Parameters:
% filename: The data file to be tested
% win_len: The length of the sliding window for testing (in samples)
% expected_var: The vector of expected variances for each sensor in the 
% given data session
% range: The acceptable range (difference) between input and actual
% computed variance for each sensor in the given data session
%
% Example:
% status = sessVarTest(105, 1, [200, 200, 200, 200, 200, 200], [10, 10, 10, 10, 10, 10])
% Tests whether the computed session mean is within the provided range of
% the specified mean for each sesnsor in the data session.
%
% 3/26/13
axis_label = {'X Acceleromter', 'Y Accelerometer', 'Z Accelerometer', 'X Gyro', 'Y Gyro', 'Z Gyro'};
fail_index = 0;
retstruct = struct('test_name', 'Sliding Window Variance Thresholding');
%Load the session from disk
session = dataLoad(filename);
for win_start = [1:size(session.data,1)-win_len]
    %Determine the mean
    varval = var(session.data(win_start:win_start+win_len,:));
    for i = [1:6]
        if(abs(varval(i) - expected_var(i)) > range(i))
            fail_index = fail_index + 1;
            fail = sprintf('%s variance out of range (%2.2f @ index %d)', axis_label{i}, varval(i), win_start);
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

