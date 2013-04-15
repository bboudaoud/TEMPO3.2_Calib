TEMPO3.2_Calib
==============

Resource Sharing for TEMPO 3.2 Calibration Data/Computation

This repo is designed to allow INERTIA team members to share progress on TEMPO 3.2 platform calibration work. This repository has several sub-directories which are described below.

Data
-----
Here data sessions can be stored. Currently this repo contains only a brief calib session performed on node 116 for the sake of gyro calibration.

<B>NOTE:</B> The sessions logged here should either have their offloaded session names and JSON files, or should be provided appropriately descriptive names (including node and session number) to avoid calibration session confusion.

Tools
-----
The tools directory includes some common scripts that may be helpful in interpreting/producing/modifying TEMPO 3.2 data in MATLAB. As of now I have included tools for:
  - Importing JSON information into MATLAB (JSONLab toolkit: http://www.mathworks.com/matlabcentral/fileexchange/33381-jsonlab-a-toolbox-to-encodedecode-json-files-in-matlaboctave)
  - Importing a data session (complete with metadata from JSON) into a MATLAB structure (w/ data and metadata fields)
  - Exporting a modified session matrix (Nx6 matrix with rows corresponding to sample points and columns corresponding to senor axis [X Accel, Y Accel, Z Accel, X Gyro, Y Gyro, Z Gyro]

In addition to these basic import/export tools some sensor axis testing scripts are made available in the Validation sub-directory. <I>TALK TO BEN IF INTERESTED IN THIS WORK</I>

Documents
-----
This section should include any documents/summaries/papers relevant to our calibration work. A previous calibration-based publication is included for now.
