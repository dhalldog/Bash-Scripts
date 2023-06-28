#!/bin/bash

Prefix=$4
NewComputerName="$(osascript -e 'Tell application "System Events" to display dialog "Enter the Asset ID Number:" default answer ""' -e 'text returned of result' 2>/dev/null)"

jamf setComputerName -name "$Prefix$NewComputerName"
/bin/sleep 15

diskutil rename "/" "$Prefix$NewComputerName"

jamf recon -assetTag "$NewComputerName"