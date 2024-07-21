#!/bin/bash

# Cleanup script to delete user and clean up home directory (/home) 

#get count of user profiles to delete
USERS_IN_HOMEDIR_COUNT="$(ls /home | wc -l)"
USERS_TO_DELETE_COUNT="$(($USERS_IN_HOMEDIR_COUNT - 1))"
DIFFERENCE="$(($USERS_IN_HOMEDIR_COUNT - $USERS_TO_DELETE_COUNT))"

# perform checks
if [[ "${USERS_TO_DELETE_COUNT}" -eq 0 ]]
then
    echo "Trivial run. Home directory has no redundant users"
    exit 1
fi

if [[ "${DIFFERENCE}" -ne 1 ]]
then
    echo "Script terminated. Risk of deleting main home directory"
    exit 1
fi

#find profile names in /etc/passwd
PROFILES_TO_DELETE="$(sudo cat /etc/passwd | tail -n ${USERS_TO_DELETE_COUNT})"

#get username of profiles and delete
for PROFILE in ${PROFILES_TO_DELETE}
do
    USER=$(echo $PROFILE | cut -d ':' -f 1)
    sudo userdel ${USER}
    sudo rm -r /home/${USER}
done

# Post-delete checks
if [[ "${?}" -eq 0 ]]
then
    echo "Extra profiles deleted successfully"
    exit 0
else
    echo "Script failed while deleting users"
    exit 1
fi