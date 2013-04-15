function result = sessVarTest(filename, expected_var, range)
% sessVarTest Function to perform variance-within-range testing
%
% report = sessVarTest(filename, var, range) writes test results to
% cell-array report
%
% Output is a cell-array with the following fields:
% [Test Status (PASS or FAIL)] [Number of Failures] [Failure 1] ... [Failure N]
%
% Parameters:
% filename: The data file to be tested
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
retstruct = struct('test_name', 'Session Variance Thresholding');

%Load the session from disk
session = dataLoad(filename);
%Determine the mean
varval = var(session.data);
for i = [1:6]
    if(abs(varval(i) - expected_var(i)) > range(i))
        fail_index = fail_index + 1;
        retstruct.fail_list{fail_index} = strcat(axis_label(i), ' variance out of range');
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

