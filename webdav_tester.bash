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


for filename in "${webdavFolder}"/*.webdav ; do

	echo "working on $filename"

	if [[ ! -z $filename ]]; then 	
		url="$(head -1 $filename)";

		tail +2 $filename | gio mount $url ;
		if [[ $? -eq 0 ]]; then
			echo "location mounted copy file ..."

			gio copy "${copyfile}" $url

			if [[ $? -eq 0 ]]; then
				echo "file copied successfully"
		        	sleep 2;
		        	gio remove "$url/${dummy}"

		        	if [[ $? -eq 0 ]]; then
		                	echo "dummy removed successfully"
		       		else 
			                echo "remove failed?"
			        fi

			else 
				echo "I am afraid, copy failed"
			fi

			echo "umount $url in 5 ..."		
			sleep 5;
			gio mount -u $url
			if [[ $? -ne 0 ]]; then
				echo "location still mounted, force umount"
				sleep 3;
				gio mount -uf $url
			fi
		else 
			echo "mount failed"
		fi
	else
		echo "filename is empthy $filename"

	fi
done

echo "========================================================" ;
