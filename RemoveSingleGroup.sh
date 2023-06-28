#!/bin/bash

#Data needed below if sharing 
apiUser=$4
apiPW=$5
jssURL=$6
$group=$7


#Grabs Serial Number from system profiler
compSerial=$(system_profiler SPHardwareDataType | awk '/Serial Number/{print $4}') 

#Grabs Computer ID from Jamf Pro based on Serial Number
compID=$(curl -X GET -H "Accept: text/xml" -su "${apiUser}:${apiPW}" "${jssURL}/JSSResource/computers/serialnumber/${compSerial}/subset/general" | xpath -e '/computer/general/id/text()')

echo "$compID"

curl -su ${apiUser}:${apiPW} -H "content-type: text/xml" "${jssURL}/JSSResource/computergroups/id/$group" -X PUT -d "<computer_group><computer_deletions><computer><id>$compID</id></computer></computer_deletions></computer_group>"


