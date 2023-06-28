#!/bin/bash

jamf recon
jamf policy
jamf policy -event print
sleep 5
osascript -e 'tell app "loginwindow" to «event aevtrrst»'

exit 0


