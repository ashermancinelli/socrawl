#! /usr/bin/env sh

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

getprocs="ps -eo pid,start,stime,command | sort -n"
getruntime="grep $name | head -n 1 | awk '{print$2}' | head -n 1"

# this loops over each line of the $config file and sets
# each line to the variable $line. awk grabs fields from this, and 
# grep is for running regexs to filter data from the pipe.
while read -r line
do
    name=$(echo $line | awk '{print $1}')
    checktime=$(echo $line | awk '{print $2}')
    runtime=$(ps -p $($getprocs | $getpid) -o etime | grep -Eo "\d{2}\:\d{2}")
    echo "Proc $name has been running for $runtime long and will notify at $checktime"
done < "$config"
