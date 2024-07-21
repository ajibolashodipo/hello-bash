#!/bin/bash

# display the UID and username of the user executing the script

# display if the user is the vagrant user or not


# my code

#USERNAME=$(whoami)
#CHECK_USER="vagrant"

#if [[ "${UID}" -eq "$CHECK_USER" ]]
#then
#echo "Hello $USERNAME, you are vagrant"
#else
#echo "You are not vagrant. Who the fuck are you, $USERNAME"
#fi


# revised code

# display the uid
echo "Your UID is ${UID}"

#only display if the UID does not match 1000
UID_TO_TEST_FOR='1000'

if [[ "${UID}" -ne "${UID_TO_TEST_FOR}" ]]
then
  echo "Your UID does not match ${UID_TO_TEST_FOR}"
  exit 1
fi

#display the username
USER_NAME=$(id -un)

#"${?}" - checks for the exit status of the last run command

#test if the command succeeded
if [[ "${?}" -ne 0 ]]
then
  echo "The id command did not execute successfully"
  exit 1
fi

echo "Your username is ${USER_NAME}"







