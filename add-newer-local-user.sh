#!/bin/bash

# Challenge 2

# Run with root privileges
if [[ "${UID}" -ne 0 ]]
then
    echo "Script must be run with root privileges" 1>&2 > error.txt
    exit 1
fi

# Check that account name (first argument) is supplied
if [[ "${#}" -lt 1 ]]
then
    echo "Usage: ${0} USER_NAME [USER_NAME]..."
    exit 1
fi

#assign input arguments to USER_DETAILS variable
USER_DETAILS="${*}"

# manipulate ACCOUNT_DETAILS to obtain account info
USER_NAME=${1}
USER_COMMENT=${2:-}

echo ${USER_NAME}
echo ${USER_COMMENT}

#generate random password
PASSWORD=$(date +%s%N | sha256sum | head -c48)

# create the account
useradd -c "${USER_COMMENT}" -m ${USER_NAME} &> /dev/null

#check to see if the useradd command succeeded
# we don't want to tell the user that an account was created whrn it hasn't been
if [[ "${?}" -ne 0 ]]
then
    echo "The account could not be created." 1>&2
    exit 1
fi

#set the password
echo "${USER_NAME}:${PASSWORD}" | chpasswd &> /dev/null

#check that last command run with an exit status of 0. fail if not 0
if [[ "${?}" -ne 0 ]]
then
    echo "The password for the account could not be set" 1>&2
    exit 1
fi

#force password change of first login
passwd -e ${USER_NAME} &> /dev/null

# display user details
echo "username:"
echo "${USER_NAME}"
echo 
echo "password:"
echo "${PASSWORD}"
echo
echo "host:"
echo "${HOSTNAME}"

exit 0