# Archival Notice
This repository has been archived and the functionality has been moved to the gem organisir hosted [here](https://github.com/anujc4/organisir). The gem was easier to manage than having a single file with all the functionalities.

# OrganiSer

Utilities for managing files in my local machine.

## Getting Started

1. Clone the repository in the location of your choice.
2. Copy the files to the base directory where you need organiSer to run
3. Execute the ruby file passing the correct

### Prerequisites

You need to install ruby on your machine to run the scripts. At the time of writing the scripts, the ruby version was 2.5.5.

For MacOS:

```
\curl -sSL https://get.rvm.io | bash -s stable --ruby
```

For Ubuntu:
Follow the steps listed in [ubuntu_rvm](https://github.com/rvm/ubuntu_rvm).

## Usage Guide

main.rb can be invoked with 2 parametes.<br/>
Param 1: The `directory_name` which has to be scanned for files which have to moved.<br/>
Param 2: The `directory_name` which has the folders in which the files from (param 1) has to be moved.

Once the script is invoked, the script goes through the folders present in the destination directory and creates regexes based on their names. Then, the source files are matched against each regex and if the file names are a match, they are moved to the source directory.

## Running the tests

Coming soon. The tests are not yet written.

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details
