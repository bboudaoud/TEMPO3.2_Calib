function outfile = makeSess(filename, data_in)
% This tool takes a filname (no extension) and input data matrix and produces the affiliated TEMPO3.2F output files include a dummy .JSON metadata file for use with the dataLoad import tools
%
% filename: The name of the .dat.gz and .json file to be produced at the output
% data_in: An Nx6 matrix of data to write

len = size(data_in,1);
for i = 0:5
    for j = 1:len
        raw(i*2*len+2*j-1) = NaN;   %% Set every odd sample (timestamp) NaN
        raw(i*2*len+2*j) = data_in(j, 1+i); %% Parse in data point
    end
end

dat_name = strcat(filename, '.dat');
file = fopen(dat_name, 'w');
fwrite(file, raw, 'float64');
fclose(file);
gzip(dat_name);


copyfile('TEMPO3.2F_dummy.json', strcat(filename, '.json'));
