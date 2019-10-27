#!/bin/bash

# each account needs a .webdav file with credentials
# located at webdavFolder - modify below

# logindata.webdav files required
# first line davs://...
# second line login name
# third line password

# mount location with gvfs-mount
# try to copy a file and remove 
# umount location

export $(dbus-launch)

webdavFolder="${HOME}/webdav"
dummy="$(date +"%Y_%m_%d")_dummy.txt"
copyfile="/tmp/$dummy"

echo "test" > "${copyfile}"

logfile=/tmp/${0}.log

for filename in "${webdavFolder}"/*.webdav ; do

	echo "working on $filename" | tee -a $logfile

	if [[ ! -z $filename ]]; then 	
		url="$(head -1 $filename)";

		tail +2 $filename | gio mount $url ;
		if [[ $? -eq 0 ]]; then
			echo "location mounted copy file ..." | tee -a $logfile

			gio copy "${copyfile}" $url

			if [[ $? -eq 0 ]]; then
				echo "file copied successfully"  | tee -a $logfile
		        	sleep 2;
		        	gio remove "$url/${dummy}"

		        	if [[ $? -eq 0 ]]; then
		                	echo "dummy removed successfully" | tee -a $logfile
		       		else 
			                echo "remove failed?" | tee -a $logfile
			        fi

			else 
				echo "I am afraid, copy failed" | tee -a $logfile
			fi

			echo "umount $url in 5 ..."	| tee -a $logfile	
			sleep 5;
			gio mount -u $url
			if [[ $? -ne 0 ]]; then
				echo "location still mounted, force umount" | tee -a $logfile
				sleep 3;
				gio mount -uf $url
			fi
		else 
			echo "mount failed" | tee -a $logfile
		fi
	else
		echo "filename is empthy $filename" | tee -a $logfile

	fi
	echo "========================================================" | tee -a $logfile
done

rm "/tmp/$dummy"


echo "$(tail -1000 $logfile)" > $logfile
