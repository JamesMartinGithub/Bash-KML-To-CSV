#!/bin/bash

#store provided arguments
inputPath=$1
outputPath=$2

#store old IFS value and set IFS to newline
oldIfs=$IFS
IFS=$'\n'

#store number of plots as variable
pointNumber=$(grep -c '<!\[CDATA\[<table>' $inputPath)

#create array storing each relevant line of data
lines=($(grep -A 9 '<!\[CDATA\[<table>' $inputPath))

#initialise data field arrays
timestamps=()
lats=()
longs=()
pressures=()
intensities=()


count=0
#loop through each plot
for line in "${lines[@]}"
do
	#reset the counter for each new plot
	if [[ "$line" == *CDATA* ]]
	then
		count=0
	fi
	#get timestamp from line [3]
	if [ $count -eq 3 ]
	then
		timestamps+=($(echo $line | awk -F'<td>' '{print $2}' | awk -F'</td>' '{print $1}'))
	fi
	#get latitude and longitude from line [5]
	if [ $count -eq 5 ]
	then
		lats+=($(echo $line | awk -F'<B>' '{print $2}' | awk -F',' '{print $1}'))
		longs+=($(echo $line | awk -F', ' '{print $2}' | awk -F'</B>' '{print $1}'))
	fi
	#get minsealevelpressure from line [7]
	if [ $count -eq 7 ]
	then
		pressures+=($(echo $line | awk -F'<td>' '{print $2}' | awk -F';' '{print $1}'))
	fi
	#get maxintensity from line [9]
	if [ $count -eq 9 ]
	then
		intensities+=($(echo $line | awk -F'<td>' '{print $2}' | awk -F';' '{print $1}'))
	fi
	#increase count for each loop so the next line is read
	count=$(($count + 1))
done

#restore old IFS value
IFS=${oldIfs}

comma=$','
#write field headings to csv file
printf "%s\n" "Timestamp,Latitude,Longitude,MinSeaLevelPressure,MaxIntensity" > $outputPath
#write data to file, each plot on a new line, fields seperated by commas
for ((e=0;e<$pointNumber;e++))
do
	echo ${timestamps[e]}$comma${lats[e]}$comma${longs[e]}$comma${pressures[e]}$comma${intensities[e]} >> $outputPath
done