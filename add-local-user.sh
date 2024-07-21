#!/bin/bash

# add local user to system

#you will be prompted to enter the username (login), the person name, and a password.

# the username, password, and host for the account will be displayed


#make sure the script is being executed with superuser privileges
if [[ "${UID}" -ne 0 ]]
then
    echo "Please run with sudo or as root"
    exit 1
fi

# get the username (login)
read -p "Enter the username to create: " USER_NAME

#get the real name (content for description field)
read -p "Enter the name of the person or application that will be using this account: " COMMENT

#get the password
read -p "Enter the password to use for the account: " PASSWORD

#create the account
useradd -c "${COMMENT}" -m ${USER_NAME}

#check to see if the useradd command succeeded
# we don't want to tell the user that an account was created whrn it hasn't been
if [[ "${?}" -ne 0 ]]
then
    echo "The account could not be created."
    exit 1
fi

# set the password
echo "${USER_NAME}:${PASSWORD}" | chpasswd

if [[ "${?}" -ne 0 ]]
then
    echo "The password for the account could not be set"
    exit 1
fi

#force password change on first login
passwd -e ${USER_NAME}

# Display the username, password, and the host where the user was created

echo
echo "username:"
echo "${USER_NAME}"
echo 
echo "password:"
echo "${PASSWORD}"
echo
echo "host:"
echo "${HOSTNAME}"

exit 0