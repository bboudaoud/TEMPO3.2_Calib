"""
Example file showing the usage of parseDatFile() to convert .dat
files from TEMPO 3.2F nodes to usable .csv files 
To run this script, replace the definition of line 45 with your own 
filename.
Requires: Python 2.7, NUMPY (http://www.numpy.org/)
Anish Simhal, 7/17/13
"""

import csv
import numpy as np

def parseDatFile(filename): 
    """
	Parses .dat files offloaded from a TEMPO 3.2F node, and creates
	a .csv file of the parsed data. 
	Returns matrix of the data, in the following order: 
		Accel {x, y, z}, Gyro {x, y, z}
	Example usage: output = parseDatFile('TEMPO3.2F-0215_s00116.dat')
	"""
    # Pull in all the raw data.
    with open(filename, 'rb') as f:
        raw = np.fromfile(f, np.float64)

    # Throw away the nan entries.
    raw = raw[1::2]

    # Check its a multiple of six so we can reshape it.
    if raw.size % 6:
        raise ValueError("Data size not multiple of six.")

    # Reshape and take the transpose to manipulate it into the
    # same shape as the original data
    data = raw.reshape((6, raw.size/6)).T.astype('int')

    # Dump it out to a CSV.
    filename = filename[:-3]
    outputFilename = filename + 'csv'
    with open(outputFilename, 'w') as f:
        w = csv.writer(f)
        w.writerows(data)
		
    return data; 
	
def main():
    filename = 'TEMPO3.2F-0215_s00116.dat' #Replace this line
    parseDatFile(filename)


if  __name__ =='__main__':
    main()