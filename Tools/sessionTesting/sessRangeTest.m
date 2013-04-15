function result = sessRangeTest(filename, min_val, max_val)
% sessRangeTest Function to perform value in range testing on a given TEMPO 
% data session
%
% report = sessRangeTest(filename, min_val, max_val) writes test results to
% cell-array report
%
% Output is a cell-array with the following fields:
% [Test Status (PASS or FAIL)] [Number of Failures] [Failure 1] ... [Failure N]
%
% Parameters:
% filename: The data file to be tested
% min_val: An array of minimum values for each sensor in the session
% max_val: An array of maximum values for each sesnor in the session
%
% Example:
% status = sessRangeTest(105, 1, [0,0,0,0,0,0], [4095, 4095, 4095, 4095, 4095, 4095])
% Tests whether each of the 6 sensor axis has a value that falls in the
% range of 0-4095 = 2^12-1 (useful for 12 bits of representation).
%
% 3/26/13
axis_label = {'X Acceleromter', 'Y Accelerometer', 'Z Accelerometer', 'X Gyro', 'Y Gyro', 'Z Gyro'};
fail_index = 0;
retstruct = struct('test_name', 'Session Range');
% Load the session from disk
session = dataLoad(filename);
% Determine min and max values
maxval = max(session.data);
minval = min(session.data);
for i = [1:6]
    if (maxval(i) > max_val(i))
        fail_index = fail_index + 1;
        retstruct.fail_list{fail_index} = sprintf('%s above critical threshold', axis_label{i});        
    end
    if (minval(i) < min_val(i))
        fail_index = fail_index + 1;
        retstruct.fail_list{fail_index} = sprintf('%s below critical threshold', axis_label{i});
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