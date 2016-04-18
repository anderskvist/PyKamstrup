#!/usr/bin/env bash

DATAFILE=/tmp/kamstrup.data

if [ $(pgrep -x $(basename ${0}) -c) -gt 1 ]; then
    echo "Already running!"
    exit
fi

while (true); do
    echo ${PID} > ${PIDFILE}
    $(dirname ${0})/kamstrup.py > ${DATAFILE}.temp

    grep "None" "${DATAFILE}.temp"
    if [ $? -ne 0 ]; then
	mv ${DATAFILE}.temp ${DATAFILE}
    else
	rm -f ${DATAFILE}.temp
    fi

    sleep 1
done