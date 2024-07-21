#!/bin/bash

# this script generates a list of random passwords

# A random number as a password
PASSWORD="${RANDOM}"
echo "${PASSWORD}"

# three random numbers together
PASSWORD="${RANDOM}${RANDOM}${RANDOM}"
echo "${PASSWORD}"

# use the current data/time as the basis for the password (PLUS NANOSECONDS)
PASSWORD=$(date +%s%N)
echo "${PASSWORD}"

# a better password
PASSWORD=$(date +%s%N | sha256sum | head -c32)
echo "${PASSWORD}"

# an even better password
PASSWORD=$(date +%s%N${RANDOM}${RANDOM} | sha256sum | head -c48)

#append special character th password
SPECIAL_CHARACTER=$(echo "!£$%^&+-=" | fold -w1 | shuf | head -c1)