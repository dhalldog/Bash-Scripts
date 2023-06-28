#!/bin/bash

#Script to Read Computer Name, Asset Tag, and Serial Number from data file then fix the computer name using the JAMF API.
#Data needed below if sharing 
apiUser=$4
apiPW=$5
jssURL=$6
#IFS takes out commas in CSV file between data points
IFS=,

#While loop searches CSV file based on serial number with JAMF API to update Device Name with Asset Tag from Same file
while read name serial asset;

do

#curl command searches the device based on serial number and changes the device name based on the asset tag from the device
compId=$(curl -su ${apiUser}:${apiPW} -H "content-type: text/xml" 
https://${jssURL}/JSSResource/computers/serialnumber/$serial | xmllint --xpath '/computer/general/id/text()' 
-)

curl -su ${apiUser}:${apiPW} -H "content-type: text/xml" ${jssURL}/JSSResource/computers/id/$mdId -X PUT 
-d "<computer><general><name>NLSD_MBP$asset</name></general></computer>"

#Source of the File replace "/PATH/TO/FILE" with your file path 
done < /PATH/TO/FILE