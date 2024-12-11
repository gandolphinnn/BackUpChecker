# BackUpChecker.bat

#### Description
BackUpChecker.bat is a batch script that checks for the existence of a configuration file, retrieves the current date, verifies the existence of a shortcut, determines the destination of the shortcut, and lists the files in the destination directory. It also checks if the files are blacklisted or if their modification date is different from the current date.

#### Requirements
Windows OS
Configuration file BackUpChecker.bat.config in the same directory as the batch script
Shortcut specified in the configuration file

#### Configuration
The configuration file BackUpChecker.bat.config should contain the following variables:

shortcutName: The name of the shortcut to check
fileBlackList: A space-separated list of filenames to be blacklisted
Usage
Ensure that the configuration file BackUpChecker.bat.config is present in the same directory as the batch script.
Run the batch script BackUpChecker.bat.

#### Notes
The script uses a temporary VBScript file to get the destination of the shortcut.
Ensure that the configuration file and the shortcut exist in the correct directory before running the script.

####  Author
Gandolphinnn

#### License
ISC License
