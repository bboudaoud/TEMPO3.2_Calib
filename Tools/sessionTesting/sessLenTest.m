function result = sessLenTest(filename, sampling_rate, range)
% sessLenTest Function to perform sample point (length) versus reported
% duration comparison test
%
% report = sessLenTest(filename, sampling_rate, range) writes test results to
% cell-array report
%
% Output is a cell-array with the following fields:
% [Test Status (PASS or FAIL)] [Number of Failures (= 0 or 1)] [Failure 1]
%
% Parameters:
% filename: The data file to be tested
% sampling_rate: The session sampling rate (in Hz)
% range: The acceptable range (difference) between reported and actual
% duration measured in seconds.
%
% Example:
% status = sessLenTest(105, 1, 128, 2)
% Tests whether the session's reported duration is within +-2s of the
% number of represented data points (@ 128Hz sampling rate)
%
% 3/26/13

% Load the session from disk
session = dataLoad(filename);
% Extract and convert time stamps from metadata
startTime = session.metadata.session_info.start_time;
endTime = session.metadata.session_info.end_time;
startTime(11) = ' ';
endTime(11) = ' ' ;
retstruct = struct('test_name', 'Session Length');

% Compute duration in seconds
duration = (datenum(endTime) - datenum(startTime))*86400;
expected_len = duration * sampling_rate;
actual_len = size(session.data, 1);
discrep = abs(actual_len - expected_len);
if(discrep < (range * sampling_rate))
    retstruct.result = 'PASS';
    retstruct.num_fail = 0;
else
    retstruct.result = 'FAIL';
    retstruct.num_fail = 1;
    retstruct.fail_list{1} = sprintf('Time discrepancy of %fs', discrep/sampling_rate);
end

result = retstruct;


