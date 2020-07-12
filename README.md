# Repo Lines Counter
This is a simple beginner Perl project to count the number of lines in a repository.
You can provide a list of file and directory names which will be ignored from the count.

### Usage Guide
See guide for installation [Installation](#Installation).

##### Files:

- **output.json**: Once you run the Perl script, a JSON file output will be generated in the root scope, named `output.json`.
That file contains the number of lines for every file and directory in the provided repository.

- **ignore.json**: This file contains the files and directories you wish to ignore while counting the number of lines in the repository.

The paths for both files can be changed in the constant variables named `OUTPUT_FILE_PATH`, `IGNORE_CONFIG_PATH` respectively.

### Installation
Head over to the [Releases](https://github.com/Alon-L/repo-lines-counter/releases) tab and download the latest release matching your Operating System.

##### Windows
Open your Command Line and navigate to the downloaded exe location.

Type the following to run it:
```
WIN_repo-lines-counter_v<YOUR VERSION> <repository URL>
```

##### Linux
Open your Terminal and navigate to the downloaded executable location.

Type the following to run it:
```
./LINUX_repo-lines-counter_v<YOUR VERSION> <repository URL>
```

### Install from Source
Run the following commands:
```
git clone https://github.com/Alon-L/repo-lines-counter
cd repo-lines-counter
perl repo-lines-counter.pl <repository URL>
```