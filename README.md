# webdavTester

## what does it do?
It tests webdav connections with gio in linux and help to keep them alive. This script can be executed for example on devices like a raspberry pi with crontab.

* mount webdav
* copy dummy file to storage
* remove dummy file from storage
* unmount webdav 

## installation
Place the script call at /etc/crontab, for example:

1 1 * * * user bash /pathToScript/webdav_test.bash

## accounts
All the webdav account files should be at $HOME/webdav, all accounts with a .webdav file will be processed.
The path can be modified in the script.

account file:
line 1: webdav url
line 2: login name
line 3: password 

