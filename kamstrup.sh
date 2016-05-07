#!/usr/bin/env bash

DATAFILE=/tmp/kamstrup.data
LOGFILE=/var/log/$(basename ${0}|cut -d"." -f1).log
EXPECTLINES=13

if [ $(pgrep -x $(basename ${0}) -c) -gt 1 ]; then
    echo "Already running!"
    exit
fi >> ${LOGFILE} 2>&1

while (true); do
    $(dirname ${0})/kamstrup.py > ${DATAFILE}.temp

    grep "None" "${DATAFILE}.temp" -q
    if [ $? -ne 0 ]; then
	if [ $(wc -l ${DATAFILE}.temp|awk '{print $1}') -eq ${EXPECTLINES} ]; then
	    mv ${DATAFILE}.temp ${DATAFILE}
	else
	    echo "$(date) Expected ${EXPECTLINES} lines in ${DATAFILE}.temp but got $(wc -l ${DATAFILE}.temp)"
	    rm -f ${DATAFILE}.temp
	fi
    else
	echo "$(date) Error in one or more line"
	rm -f ${DATAFILE}.temp
    fi
done >> ${LOGFILE} 2>&1