#!/bin/bash
set -e

# Colors
red=`tput setaf 1`
green=`tput setaf 2`
reset=`tput sgr0`

# Clear console
clear

# Warning
echo "${red}This will work on MacOS"
echo "I'm not responsible for any damages on your system"
echo "If Adobe change where the folder is located, this script will fail"
echo "This will make a back-up of the original Fujifilm X-T4 folder${reset}"
echo "Do you want to continue?"
echo "Type ${green}yes${reset} or ${red}no${reset}: "
read answ

if [ $answ = "no" ]; then
	echo "Will exit now"
	exit 0
else
	sleep 1s
fi

# Clear console
clear

# Check if script is run as root
if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

# Backup of folder
echo "Doing a BackUp of Fujifilm X-T4 folder"
cd /Applications/Adobe\ Lightroom\ Classic/Adobe\ Lightroom\ Classic.app/Contents/Resources/Settings/Adobe/Profiles/Camera/Fujifilm/
cp -r Fujifilm\ X-T4/ ~/Desktop/Fujifilm\ X-T4\ BackUp/
echo ""
sleep 5s

# Make changes
echo "Changing xmp files"
cd /Applications/Adobe\ Lightroom\ Classic/Adobe\ Lightroom\ Classic.app/Contents/Resources/Settings/Adobe/Profiles/Camera/Fujifilm/Fujifilm\ X-T4/
sed -i -e 's/crs:CameraModelRestriction="Fujifilm X-T4"/crs:CameraModelRestriction=""/1' Fujifilm\ X-T4\ Camera\ BLEACH\ BYPASS.xmp
sed -i -e 's/crs:CameraModelRestriction="Fujifilm X-T4"/crs:CameraModelRestriction=""/1' Fujifilm\ X-T4\ Camera\ CLASSIC\ Neg.xmp
sed -i -e 's/crs:CameraModelRestriction="Fujifilm X-T4"/crs:CameraModelRestriction=""/1' Fujifilm\ X-T4\ Camera\ Sepia.xmp
rm *.xmp-e
echo ""
sleep 5s

# Done
if [ $(cat Fujifilm\ X-T4\ Camera\ BLEACH\ BYPASS.xmp | grep 'CameraModelRestriction') = 'crs:CameraModelRestriction=""' ]; then
	echo "${green}ALL DONE${reset}"
else
	echo "Something went wrong"
	echo "Restoring old folder"
	cd /Applications/Adobe\ Lightroom\ Classic/Adobe\ Lightroom\ Classic.app/Contents/Resources/Settings/Adobe/Profiles/Camera/Fujifilm/
	rm -r Fujifilm\ X-T4/
	cd ~/Desktop/
	cp -r Fujifilm\ X-T4\ BackUp/ /Applications/Adobe\ Lightroom\ Classic/Adobe\ Lightroom\ Classic.app/Contents/Resources/Settings/Adobe/Profiles/Camera/Fujifilm/
	cd /Applications/Adobe\ Lightroom\ Classic/Adobe\ Lightroom\ Classic.app/Contents/Resources/Settings/Adobe/Profiles/Camera/Fujifilm/
	mv Fujifilm\ X-T4\ BackUp/ Fujifilm\ X-T4/
	echo "Restored !!"
fi
