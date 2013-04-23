function output = calibrateData(sensorData, jsonFile)
%This function inputs the .gz and .json file offloaded from 
%TEMPO, applies the calibration values, 
%and returns the calibrated data
%feel free to edit as needed. 
output = dataSplit(sensorData); 
figure()
plot(output(:, 4:6)); 
calib = loadjson(jsonFile); 
xB = mean(calib.session_info.calibration.x_plane_zeros); 
yB = mean(calib.session_info.calibration.y_plane_zeros);
zB = mean(calib.session_info.calibration.z_plane_zeros);
xA = (calib.session_info.calibration.x_plane_pos - ...
    calib.session_info.calibration.x_plane_neg)/2; 
yA = (calib.session_info.calibration.y_plane_pos ...
    - calib.session_info.calibration.y_plane_neg)/2; 
zA = (calib.session_info.calibration.z_plane_pos - ...
    calib.session_info.calibration.z_plane_neg)/2; 
%[xA, yA, zA] = deal(500); 
%[xB, yB, zB] = deal(1700); 

%output 
output(:, 4) = output(:, 4) - xB; 
output(:, 4) = output(:, 4)*(33/xA); 
output(:, 5) = output(:, 5) - yB;
output(:, 5) = output(:, 5)*(33/yA); 
output(:, 6) = output(:, 6) - zB;
output(:, 6) = output(:, 6)*(33/zA); 
figure()
plot(output(:, 4:6));

function a_out=dataSplit(inputFile)
%Function to convert TEMPO3.2F .dat output files into a .csv file
%Output file has six columns in the following order: 
%X-Accel, Y-Accel, Z-Accel, X-Gyro, Y-Gyro, Z-Gyro
%inputFile: filename (w/o the .gz) extension 
%return: matrix object with parsed data
%example call: a=dataSplit('tempo.dat', 'tempo.csv')
%3/18/13

%file reading code
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