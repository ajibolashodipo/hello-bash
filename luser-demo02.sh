#!/bin/bash


# display  the uid and username of user executing the script

# display if the user is the root or not


#display the uid
echo "Your UID is ${UID}"

#display the username
USER_NAME=$(id -un)
echo "Your username is ${USER_NAME}"

# display if the user is root user or not
if [[ "${UID}" -eq 0 ]]
then
  echo "You are root"
else
  echo "You are not root"
fi

