#!/bin/bash
#
# KillProcesses.sh
#
# This script can be used to kill R processes on a list of machines.  This is
# useful when an experiment run using R and snowfall needs to be halted
# prematurely.

# Name of the file containing the hostnames is the first command-line argument.
FILE=$1
# Name of the user whose R processes will be killed.
USER=$2

# Kill all processes containing "R" in their name on each machine.
# NOTE 1: This might kill non-R processes - use the exact name of the process
# if you know it.
# NOTE 2: Unless you are using passwordless ssh, you will need to re-enter your
# password for every host.
while read LINE
do
    echo "here1" >> file1
    ssh $LINE "pkill -u $USER R" >> file1
    echo "here2" >> file1
    pkill -u $USER R
    echo "here3" >> file1
    #exit
    echo "here4" >> file1
done < $FILE
