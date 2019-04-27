#!/usr/bin/env bash

if test -f ./config
then
    echo "Found local config file."
    config=./config
else
    echo "Could not find config file."
    exit
fi

os=$(uname -a | awk '{print $1}')
echo "Found $os OS"

# Function which removes '-' and ':' characters
# from a string so it can be interpreted as a number
# for checking threshholds
function cleanTime() {
    echo $1 | sed 's/[-\:]//g'
}

# this loops over each line of the $config file and sets
# each line to the variable $line. awk grabs fields from this, and 
# grep is for running regexs to filter data from the pipe.
while read -r line
do

    # This checks to see if the line containes a '#', and 
    # if so, the line is regarded as a comment and is skipped.
    if [ $(echo $line | grep -v "#" | wc -l) -eq 0 ]
    then
        continue
    fi

    # awk grabs the first column of the line here, which is the name
    name=$(echo $line | awk '{print $1}')

    # checktime grabs the given time in the config file, 2nd column
    checktime=$(echo $line | awk '{print $2}')

    # grabs how long the PID has been running after getting the PID
    # $getprocs | $getpid grabs all the processes with a given name
    # and filters for just the longest running one, and the rest of this line
    # uses grep to just get the running time in MINS:SECS 
    runtime=$(ps -eo etime,pid,command | sort -n | grep $name | tail -n 1 | awk '{print$1}')

    # echos out for debugging
    echo "Proc $name has been running for $runtime long and will notify at $checktime"

    if [ "$(cleanTime $runtime)" -ge "$(cleanTime $checktime)" ]
    then
        # We will use this to contact the server once that part of the 
        # program is up. Right now this just prints if the proc has
        # been running long enough to trigger event.
        # resp=$(curl SERVERNAME/$proc)
        # echo "Server response: $resp"
        echo "$name has been running long enough to trigger event"
    fi

# this bottom line throws all the data from the 
# given file into the loop
done < "$config"
