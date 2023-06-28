#!/bin/bash

loggedInUser=$(stat -f%Su /dev/console)
jamfHelper="/Library/Application Support/JAMF/bin/jamfHelper.app/Contents/MacOS/jamfHelper"
windowType="hud"
description="Your computer has not been restarted in the last 14 days. We recommend restarting often as it helps to keep things in check and your computer up to date with anything we push out. If you are unable to perform this restart at the moment, please select 'Cancel.'

***Please save all working documents before selecting 'Restart'"

button1="Restart"
button2="Cancel"
title="Critical: Your computer has not restarted in more than 14 days"
alignDescription="left" 
alignHeading="center"
defaultButton="2"
timeout="900"

# JAMF Helper window as it appears for targeted computers
userChoice=$("$jamfHelper" -windowType "$windowType" -lockHUD -title "$title" -timeout "$timeout" -defaultButton "$defaultButton" -description "$description" -alignDescription "$alignDescription" -alignHeading "$alignHeading" -button1 "$button1" -button2 "$button2")

# If user selects "Restart"
if [ "$userChoice" == "0" ]; then
   echo "User clicked Restart; now restarting the computer."
   # Present user with 60 second countdown to restart computer; user may opt out of restart
   osascript -e 'tell app "loginwindow" to «event aevtrrst»'
# If user selects "Cancel"
elif [ "$userChoice" == "2" ]; then
   echo "User clicked Cancel or timeout was reached; now exiting."
   exit 0    
fi