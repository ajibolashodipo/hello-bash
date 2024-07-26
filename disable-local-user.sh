#!/bin/bash

# this script disables, deletes and/or archives users on the local system

ARCHIVE_DIR="/archive"


usage(){
    #display the usage and exit
    echo "Usage: ${0} [-dra] USER [USERN]..." >&2
    echo "Disable a local linux account." >&2
    echo " -d Deletes accounts instead of disabling them." >&2
    echo " -r removes the home directory associated with the account(s)." >&2
    echo " -a creates an archive of the home directory associatedwith the account(s)" >&2
    exit 1
}

#make sure the script is being executed with superuser privileges
if [[ "${UID}" -ne 0 ]]
then
    echo "Please run with sudo or as root." >&2
    exit 1
fi

#parse the options
while getopts dra OPTION
do
    case ${OPTION} in
    d) DELETE_USER="true";;
    r) REMOVE_OPTION="-r";;
    a) ARCHIVE="true";;
    ?) usage ;;
    esac
done

#remove the options while leaving the remaining arguments
shift "$(( OPTIND -1))"

#if the user does not supply at least one argument, give them help
if [[ "${#}" -lt 1 ]]
then
    usage
fi

# loop throug hall the usernames supplied as arguments
for USERNAME in "${@}"
do
    echo "Processing user: ${USERNAME}"

    #make sure the uid of the account is at least 1000
    USERID=$(id -u ${USERNAME})
    if [[ "${USERID}" -lt 1000 ]]
    then
        echo "Refusingto remove the ${USERNAME} account with UID ${USERID}." >&2
        exit 1
    fi

    # create an archive if requested to do so
    if [[ "${ARCHIVE}" = "true" ]]
    then
    #make sure the archive_dir directory exists
    if [[ ! -d "${ARCHIVE_DIR}" ]]
    then
        echo "Creating ${ARCHIVE_DIR} directory"
        mkdir -p ${ARCHIVE_DIR}
        if [[ "${?}" -ne 0 ]]
        then
            echo "The archive directory ${ARCHIVE_DIR} could not be created." >&2
            exit 1
        fi
    fi

    #archive the user's home dir and move it into the ARCHIVE_DIR
    HOME_DIR="/home/${USERNAME}
    ARCHIVE_FILE= "${ARCHIVE_DIR}/${USERNAME}.tgz
    if [[ -d "${HOME_DIR}" ]]
    then
        echo "Archiving ${HOME_DIR} to ${ARCHIVE_FILE}." >&2
        tar -zcf ${ARCHIVE_FILE} ${HOME_DIR} &> /dev/null
        if [[ "${?}" -ne 0 ]]
        then
            echo "Could not create ${ARCHIVE_FILE}" >&2
            exit 1
        fi
    else
        echo "${HOME_DIR} does not exist or is not a directory." >&2
        exit 1
    fi

    if [[ "${DELETE_USER}" = "true"]]
    then
        #delete the user
        userdel ${REMOVE_OPTION} ${USERNAME}

        #Check to see if the userdel command succeeded
        # we dont want to tell the user that an account was deleted when it hasnt been
        if [[ "${?}" -ne 0 ]]
        then
            echo "The account ${USERNAME} was not deleted" >&2
            exit 1
        fi
        echo "The account ${USERNAME} was deleted"
    else
        chage -E 0 ${USERNAME}


        #Check to see if the userdel command succeeded
        # we dont want to tell the user that an account was deleted when it hasnt been
        if [[ "${?}" -ne 0 ]]
        then
            echo "The account ${USERNAME} was not disabled" >&2
            exit 1
        fi

        echo "The account ${USERNAME} was disabled"
    fi
done

exit 0

