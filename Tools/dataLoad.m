function a_out = dataLoad(filename)
%Function to convert TEMPO3.2F .dat output files into a .csv file
%Output file has six columns in the following order: 
%X-Accel, Y-Accel, Z-Accel, X-Gyro, Y-Gyro, Z-Gyro
%inputFile: filename
%return: matrix object with parsed data
%example call: a=dataSplit('tempo.dat', 'tempo.csv')
%3/18/13
fname = filename(1:findstr('.dat.gz', filename)-1);
outputFile = strcat(fname, '.csv');

% Data file import
gunzip(filename);
dat_name = strcat(fname, '.dat');
dat_fid = fopen(dat_name);
raw = fread(dat_fid, 'float64');

% Metadata file import
mdata = loadjson(strcat(fname, '.json'));

% get number of entries 
sz = max(size(raw));
data = reshape(raw, sz, 1);

%format Matrix
%Method to format 1 col by infinite rows into proper format
%set rows to be the upper limit 
rows = ceil(length(data)/12); 
%columns - 6
column=6; 
%create empty array with zeros 
output=zeros(rows, column); 
%data format is NaN; number; Nan; Number
r=1; 
c=1;  
len = length(data);
%disp(len); 
j = 0; 
for i = 1:len
    if mod(i, 2) == 0   %% Take only the even (non-timestamp values)
        output(r, c) = data(i);
        r = r + 1;
        j = j + 1; 
        if (j == len/12)    %% When we get to the length of the array over 12 (2 values per each of 6 channels)
            c = c + 1;      %% Move to the next column (sensor axis)
            j = 0;  
            r = 1;
        end 
    end 
end 
fclose(dat_fid);
delete(dat_name);
a_out = struct('data', output, 'metadata', mdata); 