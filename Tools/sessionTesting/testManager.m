function result = testManager(test_file, test_path)
teststruct = struct();
disp('Loading test file...');
fid = fopen(test_file);
% Test for appropriate text file header
temp_str = fgets(fid);
if(isempty(findstr('TEST FILE', temp_str)))
    error('The provided file is not a correctly formatted test file');
end
% Parse first 2 lines for deployment name and description
temp_str = fgets(fid);
temp_str = temp_str(1:size(temp_str,2)-2);
teststruct.deployment_name = temp_str;
temp_str = fgets(fid);
temp_str = temp_str(1:size(temp_str,2)-2);
teststruct.deployment_description = temp_str;
% Set up output file
out_name = strcat(teststruct.deployment_name, '_', date, '.txt')
repout = fopen(out_name, 'w');
fprintf(repout, '%s REPORT FILE\n Created: %s\n', upper(teststruct.deployment_name), date);
% Parse whitespace to node list
temp_str = fgets(fid);
while (isempty(findstr('Node List: ', temp_str)))
    temp_str = fgets(fid);
end
% Parse node list
teststruct.node_list = str2num(temp_str(findstr(':', temp_str)+2:size(temp_str,2)-2));
% Parse whitespace to start of test list
temp_str = fgets(fid);
while (isempty(findstr('BEGIN', temp_str)))
    temp_str = fgets(fid);
end
% Load test list
disp('Parsing test list...');
temp_str = fgets(fid);
test_index = 1;
while(isempty(findstr('END', temp_str)))
    % If field is not just CR+LF
    if(size(temp_str,2) > 2 && isempty(findstr('#', temp_str)))
        colon_loc = findstr(':', temp_str);
        test_list{test_index} = temp_str(1:colon_loc-1); % Extract test name
        comma_loc = findstr(',', temp_str);
        commas = size(comma_loc,2);
        i = 1;
        param_vec{i} = temp_str(colon_loc+2:comma_loc(1)-1);
        if (commas > 1)
            for i = [2:commas]
                param_vec{i} = temp_str(comma_loc(i-1)+1:comma_loc(i)-1);
            end
        end
        param_vec{i+1} = temp_str(comma_loc(commas)+2:size(temp_str,2)-2);
        param_list{test_index} = param_vec;
        test_index = test_index + 1;
    end
    temp_str = fgets(fid);
end
% Load performed test CSV
disp('Loading previous test logs...');
no_sess = 0;
csvname = strcat(teststruct.deployment_name, '.csv');
try
    performed_tests = importdata(csvname);
    performed_tests = performed_tests{1};
catch
    disp('No previously logged tests found, testing all available sessions');
    performed_tests = '';
end
%if(~no_sess) % Check that there are some sessions
%    comma_loc = findstr(',', performed_tests);
%    commas = size(comma_loc,2);
%    comma_loc(commas+1) = size(performed_tests,2)-1;
%    finished_tests{1} = performed_tests(1:comma_loc(1)-1);
%    if(commas > 1)
%        for i = [2: commas+1]
%            finished_tests{i} = performed_tests(comma_loc(i-1)+1:comma_loc(i)-1);
%        end
%    end
%end
% Cache list of available sessions
chdir(test_path);
dir_list = ls;
temp_index = 1;
for i = [3:size(dir_list,1)]
    if(~isempty(findstr('TEMPO3.2F', dir_list(i,:))) && ~isempty(findstr('.dat.gz', dir_list(i,:))))
        avail_sess_list{temp_index} = dir_list(i,1:size(dir_list(i,:),2));
        temp_index = temp_index + 1;
    end
end
% Find tests not yet performed
disp('Parsing tests to perform...');
temp_index = 1;
sess_to_test = {}; 
for i = [1:size(avail_sess_list,2)]
    if(isempty(findstr(avail_sess_list{i}, performed_tests))) % test not performed
        sess_to_test{temp_index} = avail_sess_list{i};
        temp_index = temp_index + 1;
    end
end
% Carry out requested tests on these sessions
temp_index = 1;
num_sess = size(sess_to_test,2);
if(num_sess > 0)
    for i = [1:size(sess_to_test,2)]
        disp(sprintf('\nPerforming tests on session: %s', sess_to_test{i}));
        fprintf(repout, '\nSession: %s\n', sess_to_test{i});
        for j = [1:size(test_list,2)]
            cmd = strcat(test_list{j}, 'Test(''', sess_to_test{i}, '''');
            for k = [1:size(param_list{j},2)]
                cmd = strcat(cmd, ', ', param_list{j}{k});
            end
            cmd = strcat(cmd, ')');
            disp(sprintf('>>> Running test: %s', cmd(1:findstr('Test',cmd)-1)));
            test_results{temp_index} = eval(cmd);
            disp(sprintf('>>> Result: %s', test_results{temp_index}.result));
            fprintf(repout, '[%s]: %s\n', cmd(1:findstr('Test', cmd)-1), test_results{temp_index}.result);
            if(test_results{temp_index}.result == 'FAIL')
                for m = [1:test_results{temp_index}.num_fail]
                    fprintf(repout, '     Fail %d: %s\n', m, test_results{temp_index}.fail_list{m});
                end
            end
            temp_index = temp_index + 1;
        end
    end
    teststruct.results = test_results;
    %Add recently run tests to performed list
    for i = [1:size(sess_to_test,2)]
        performed_tests = sprintf('%s, %s',performed_tests, sess_to_test{i});
    end
    % Output CSV list
    disp(sprintf('\nUpdating deployment CSV file...'));
    csvout = fopen(csvname, 'w');
    fprintf(csvout, '%s', performed_tests);
    fclose(csvout);
    % Output test report
    disp(sprintf('Writing report file out...'));
    fclose(repout);
else
    disp('No new sessions to test.');
    fclose(repout);
    delete(out_name);
end

result = teststruct;