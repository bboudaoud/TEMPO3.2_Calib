function outfile = exportSess(sess_struct)
% Input should be a MATLAB TEMPO data session (data and metadata)

    
fname = sess_struct.metadata.data_file;
fname = fname(1:findstr(fname,'.gz')-1);
file = fopen(fname, 'w');
json_file = strcat(fname(1:findstr(fname, '.dat')-1), '.json');
json = savejson('',sess_struct.metadata, json_file);

% Create raw stream for output file
data = sess_struct.data;
len = size(data,1);
for i = 0:5
    for j = 1:len
        raw(i*2*len+2*j-1) = NaN;   %% Set every odd sample (timestamp) NaN
        raw(i*2*len+2*j) = data(j, 1+i); %% Parse in data point
    end
end
% Write output stream to .dat file
fwrite(file, raw, 'float64');
fclose(file);
% Gzip the output and clean up
gzip(fname);
delete(fname);
