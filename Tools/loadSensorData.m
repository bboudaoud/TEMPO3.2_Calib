function a_out=loadSensorData(inputFile)
%Function to convert TEMPO3.2F .dat output files into a .csv file
%Output file has six columns in the following order: 
%X-Accel, Y-Accel, Z-Accel, X-Gyro, Y-Gyro, Z-Gyro
%inputFile: filename (w/o the .gz) extension 
%return: matrix object with parsed data
%example call: a=dataSplit('tempo.dat')
%3/18/13

%file reading code
inputFilegz = strcat(inputFile, '.gz'); 

gunzip(inputFilegz); 
raw = fread(fopen(inputFile), 'float64');
size(raw)

% get number of entries 
sz = max(size(raw));
disp('size is ');
disp(sz); 
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
    if mod(i, 2) == 0
        output(r, c) = data(i);
        r = r + 1;
        j = j+1; 
 
        if (j == len/12)
            c = c+1; 
            j = 0; 
            r=1;
        end 
    end 
end 

a_out=output; 