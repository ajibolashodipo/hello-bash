#!/bin/bash

# demonstrate the use of shift and while loops

# display the first 3 parameters

# echo "Parameter 1: ${1}"
# echo "Parameter 2: ${2}"
# echo "Parameter 3: ${3}"

#loop through all positional parameters
while [[ "${#}" -gt 0 ]]
do
    echo "Number of parameters: ${#}"
    echo "Parameter 1: ${1}"
    echo "Parameter 2: ${2}"
    echo "Parameter 3: ${3}"
    echo
    shift
done