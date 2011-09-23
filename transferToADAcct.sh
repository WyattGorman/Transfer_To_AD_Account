#!/bin/bash

# Authors: Nik & Wyatt Gorman
# Version: 09.08.2011
# Designed For: SUNY Geneseo - CIT Dept

# The following script moves files from an old user account
# to a new AD bound user account folder

# For this script to run properly you must input two arguments
# $OLDUSER is the name of the old user's account folder. I would suggest
# naming it "old" before starting this script.
# The other, $NEWUSER, is the name of the new user account.

# To use this simply input the old user and new user when prompted.
# A list of the /Users/ folder will be output to chose from.

# In the future I would like this to be run with an automator script.
# OK Let's get started!

function main()
{
	# The variables we will be using
	OLDUSER='old'
	NEWUSER='new'
	PRECEDINGPATH='Users'

	# Clear the screen
	clear

	# Display a nice header
	echo "			-- SUNY Geneseo: CIT --		"
	echo "	      	       User Data Migration Script		"
	echo

	# Print out current /Users/ directory
	echo Current Users Directory...
	echo ----------------------------
	ls /$PRECEDINGPATH/
	echo ----------------------------

	# Prompt for and read in old users folder name
	echo
	echo -n "Chose a source user folder: "
	read OLDUSER

	# Prompt for and read in new users folder name
	echo
	echo -n "Chose a destination user folder: "
	read NEWUSER

	# Check if the source and destination folder were entered properly and exist...
	if [ -d /$PRECEDINGPATH/$OLDUSER ]
	then
		if [ -d /$PRECEDINGPATH/$NEWUSER ]
		then
			# If they both exist, start the data transfer process.
			# I only seperated this because of all the tabs. Oh god, the tabs.
			transferData
		else
			# If they don't exist, inform the user.
			echo "Your destination folder does not exist. Please create the folder and try again."
		fi
	else
		echo "Your source folder does not exist. Please make sure you entered the path correctly."
	fi
}

function transferData()
{
	##################
	## Commence user data migration...
	##################

	echo
	echo ----------------------------
	echo Executing user data transfer from $OLDUSER to $NEWUSER ...
	echo ----------------------------

	## change the ownership of the files in the old user directory to be owned by the New User
	chown -Rv $NEWUSER /$PRECEDINGPATH/$OLDUSER/*

	## change the group ownership of the files in the new AD Directory to be owned by the new AD User group
	chgrp -Rv "GENESEO\domain users" /$PRECEDINGPATH/$NEWUSER/*

	##Move the contents of the Desktop folder
	mv -fv /$PRECEDINGPATH/$OLDUSER/Desktop/* /$PRECEDINGPATH/$NEWUSER/Desktop/

	##Move the contents of the Documents folder
	mv -fv /$PRECEDINGPATH/$OLDUSER/Documents/* /$PRECEDINGPATH/$NEWUSER/Documents/

	##Move the contents of the folder
	mv -fv /$PRECEDINGPATH/$OLDUSER/Downloads/* /$PRECEDINGPATH/$NEWUSER/Downloads/

	##Move the Firefox folder
	mv -fv /$PRECEDINGPATH/$OLDUSER/Library/"Application Support"/Firefox/* /$PRECEDINGPATH/$NEWUSER/Library/"Application Support"/Firefox/

	##Move the Addressbook folder
	mv -fv /$PRECEDINGPATH/$OLDUSER/Library/"Application Support"/Addressbook /$PRECEDINGPATH/$NEWUSER/Library/"Application Support"/

	# Move the mail folder
	mv -fv /$PRECEDINGPATH/$OLDUSER/Library/Mail  /$PRECEDINGPATH/$NEWUSER/Library/

	## Move the user fonts
	mv -fv /$PRECEDINGPATH/$OLDUSER/Library/Fonts/*.* /$PRECEDINGPATH/$NEWUSER/Library/Fonts/

	## Move the preferences for the mail
	mv -fv /$PRECEDINGPATH/$OLDUSER/Library/Preferences/com.apple.mail.plist /$PRECEDINGPATH/$NEWUSER/Library/Preferences/

	## Move the Dock preferences
	mv -fv /$PRECEDINGPATH/$OLDUSER/Library/Preferences/com.apple.dock.plist /$PRECEDINGPATH/$NEWUSER/Library/Preferences/
	
	#Move the Safari Preferences
	mv -fv /$PRECEDINGPATH/$OLDUSER/Library/Preferences/com.apple.Safari.plist /$PRECEDINGPATH/$NEWUSER/Preferences/

	#Move the Safari files
	mv -fv /$PRECEDINGPATH/$OLDUSER/Library/Safari /$PRECEDINGPATH/$NEWUSER/Library/

	#Move the Thunderbird folder
	mv -fv /$PRECEDINGPATH/$OLDUSER/Library/Thunderbird /$PRECEDINGPATH/$NEWUSER/Library/

	## Move the old login keychain
	mv -fv /$PRECEDINGPATH/$OLDUSER/Library/Keychains/login.keychain /$PRECEDINGPATH/$NEWUSER/Library/Keychains/

	##Move the contents of the Movies folder
	mv -fv /$PRECEDINGPATH/$OLDUSER/Movies/* /$PRECEDINGPATH/$NEWUSER/Movies/

	##Move the contents of the Music folder
	mv -fv /$PRECEDINGPATH/$OLDUSER/Music/* /$PRECEDINGPATH/$NEWUSER/Music/

	##Move the contents of the Pictures folder
	mv -fv /$PRECEDINGPATH/$OLDUSER/Pictures/* /$PRECEDINGPATH/$NEWUSER/Pictures/

	##Move the contents of the Public folder
	mv -fv /$PRECEDINGPATH/$OLDUSER/Public/* /$PRECEDINGPATH/$NEWUSER/Public/

	##Move the contents of the Sites folder
	mv -fv /$PRECEDINGPATH/$OLDUSER/Sites/* /$PRECEDINGPATH/$NEWUSER/Sites/	

	# Check to see if the transfer completed.
	if [ -s /$PRECEDINGPATH/$NEWUSER/Library/Preferences/com.apple.dock.plist ]
	then
		if [ -s /$PRECEDINGPATH/$NEWUSER/Library/Fonts/ ]
		then
			echo 
			#Do nothing, continue to the "congrats, it's done!" prompt.
		else
			# Tell the user something went horribly wrong.
			echo "Something went wrong with the data transfer. Not all files were copied."
			exit
		fi
	else
		echo "Something went wrong with the data transfer. Not all files were copied."
		exit
	fi

	# Do we want to remove the $OLDUSER folder here?	
	
	# Tell the user that the work is completed.
	echo File Migration Complete!
	
	# Pause to see if the user wants to go again or end it there.
	pause "Type \"exit\" and press Enter to quit. Or press any key to transfer another user's data..."
}

function pause()
{
	# Just to make the transition to another file transfer nicer...
	read -p "$*" PAUSE
	if [ $PAUSE == 'exit' ]
	then
	 	exit
	else
		# They want to go again! Hooray!
		main
	fi
}

# Call the main function to start the party!
main
