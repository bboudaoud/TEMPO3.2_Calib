function result = sessMeanTest(filename, expected_mean, range)
% sessMeanTest Function to perform mean-value-within-range testing
%
% report = sessMeanTest(filename, mean, range) writes test results to
% cell-array report
%
% Output is a cell-array with the following fields:
% [Test Status (PASS or FAIL)] [Number of Failures] [Failure 1] ... [Failure N]
%
% Parameters:
% filename: The data file to be tested
% expected_mean: The vector of expected means for each sensor in the given
% data session
% range: The acceptable range (difference) between input and actual
% computed mean for each sensor in the given data session
%
% Example:
% status = sessMeanTest(105, 1, [2048, 2048, 2048, 1800, 1800, 1800], [200, 200, 200, 200, 200, 200])
% Tests whether the computed session mean is within the provided range of
% the specified mean for each sesnsor in the data session.
%
% 3/26/13
axis_label = {'X Acceleromter', 'Y Accelerometer', 'Z Accelerometer', 'X Gyro', 'Y Gyro', 'Z Gyro'};
fail_index = 0;
retstruct = struct('test_name', 'Session Mean Thresholding');
%Load the session from disk
session = dataLoad(filename);
%Determine the mean
meanval = mean(session.data);
for i = [1:6]
    if(abs(meanval(i) - expected_mean(i)) > range(i))
        fail_index = fail_index + 1;
        retstruct.fail_list{fail_index} = strcat(axis_label(i), ' mean out of range');
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

