#!/bin/bash

#Data needed below if sharing
apiUser=$4
apiPW=$5
jssURL=$6
groups=(42 40 36 47 45 48 39 44 43 46 37 38 41)

sudo lpstat -p | cut -d' ' -f2 | xargs -I{} lpadmin -x {}
sleep 2

#Grabs Serial Number from system profiler
compSerial=$(system_profiler SPHardwareDataType | awk '/Serial Number/{print $4}')

#Grabs Computer ID from Jamf Pro based on Serial Number
compID=$(curl -X GET -H "Accept: text/xml" -su "${apiUser}:${apiPW}" "${jssURL}/JSSResource/computers/serialnumber/${compSerial}/subset/general" | xpath -e '/computer/general/id/text()')

echo "$compID"

#For loop to remove each Static Group from the array above.
for printer in ${groups[@]}; do
	curl -su ${apiUser}:${apiPW} -H "content-type: text/xml" "${jssURL}/JSSResource/computergroups/id/${printer}" -X PUT -d "<computer_group><computer_deletions><computer><id>${compID}</id></computer></computer_deletions></computer_group>"
	echo $printer
done

#Sleeps computer for 3 seconds to give time to remove groups.
sleep 3

#Runs Event Print to reload default printers back onto the machine. 
sudo jamf policy -event print
