#!/bin/bash

# function log{
#     echo "you called the log function again"
# }


log(){
    #this function sends a message to syslog and to standard output if verbose is true
    local MESSAGE="${@}"
    if [[ "${VERBOSE}" = "true" ]]
    then
        echo "${MESSAGE}"
    fi

    logger -t luser-demo10.sh "${MESSAGE}"
}

backup_file(){
  # this function creates a backup of a file. Returns non-zero status on error.
    local FILE="${1}"

    #Make sure the file exists
    if [[ -f "${FILE}" ]]
    then   
        local BACKUP_FILE="/var/tmp/$(basename ${FILE}).$(date +%F-%N)"
        log "Backing up ${FILE} to ${BACKUP_FILE}."

        #the exit status of the function will be the exit status of the cp command
        cp -p ${FILE} ${BACKUP_FILE}
    else
        # the file does not exist, so return a non-zero exit status
        return 1
    fi

}

readonly VERBOSE="true"
log "Hello"
log "This is fun"

backup_file /etc/passwd

# make a decision based on the exit status of the function
if [[ "${?}" -eq "0" ]]
then
    log "File backup succeeded"
else
    log "File backup failed!"
    exit 1
fi
