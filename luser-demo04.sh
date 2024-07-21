#!/bin/bash

#this script creates an account on the local system
#you will be prompted for the account name and password

# ask for the user name
read -p "Enter the username to create: " USER_NAME

#ask for the real name
read -p "Enter the name of the person who this account is for: " COMMENT

# ask for the password
read -p "Enter the password to use for the account: " PASSWORD

#crate the user
useradd -c "${COMMENT}" -m ${USER_NAME}

#set the password for the user
echo "${USER_NAME}:${PASSWORD}" | chpasswd

#force password change on first login
passwd -e ${USER_NAME}

