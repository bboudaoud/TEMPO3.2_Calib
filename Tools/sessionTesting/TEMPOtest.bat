@ ECHO OFF
:: Script Path Variables
SET MPATH=G:\Dropbox\School\CPS\Validation :: Path of the testManager.m script
SET JPATH=%MPATH%\jsonlab\ :: Path of the jsonlab toolkit
SET FPATH=%MPATH% :: Path of the data files to be tested
SET TEST_FILE=test_deployment.txt :: The location of the test file

:: MATLAB function call (closes on completion)
MATLAB -r cd('%MPATH%'),addpath('%JPATH%'),testManager('%TEST_FILE%','%FPATH%'),quit

