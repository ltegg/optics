#!/bin/bash

echo --------------------------------
echo lapw1_check.sh
echo Reports k-point progress through a single iteration of lapw1

## Find out how far we are through the current lapw1 cycle
# grep *.output1 for the number of instances of '    K='
more *.output1 | grep "     K=" | wc -l > prog.temp

# read this temporary file to get a bash variable of the progress
read prog < prog.temp

# Find out the total number k-points
# pipe the number of lines in *.klist to a temporary file
more *.klist | wc -l > total.temp

# read the temporary files to make a bash variable of the line count
read lines < total.temp

# the total number of k-points is the number of lines minus 2
ktotal=$(expr $lines - 2)

# calculate the ratio as a percentage
percent=$(echo "scale = 2; 100 * $prog / $ktotal" | bc)

## Housekeeping
# remove both temporary files
rm prog.temp
rm total.temp

## Print things
# Print the number of k-points calculated so far/total k-points
echo "   Progress: $prog/$ktotal ($percent%) k-points calculated in this cycle"

# Find the pid of the lapw1 process
pid=$(pgrep lapw1 -o)

# Select only the first 5 digits
pid=${pid:0:5}

# Find the walltime of this pid
time=$(ps -p $pid -o etime=)

# Remove some whitespace from the start
time=${time:3:20}

# Print the walltime and the pid of the lapw1 process
echo "   lapw1 runtime this cycle (hh:mm:ss): $time (PID = $pid)"

# done
echo "Done!"
echo --------------------------------
