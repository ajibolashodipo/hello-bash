#!/bin/bash

# this script demonstrates I/O redirection

#redirect stdout to a file
FILE="/tmp/data"
head -n1 /etc/passwd > ${FILE}

#redirect stdin (one line) to a file
read LINE < ${FILE}
echo "LINE contains ${LINE}"

#redirect stdout to a file, overwriting the file
head -n3 /etc/passwd > ${FILE}

cat ${FILE}

echo "trying not to overwrite"


# >> appends to content of file as opposed to > which overwrites
echo "another line" >> ${FILE}

cat ${FILE}

# redirect stdin to a program, using FD 0
read LINE 0< ${FILE}
echo
echo "LINE contains: ${LINE}"

# redirect STDOUT to a file using FD1, overwriting the file
head -n3 /etc/passwd 1> ${FILE}
echo
echo "Contents of ${FILE}:"
cat ${FILE}

#redirect STDERR to a file using FD2
ERR_FILE="/tmp/data.err"
head -n3 /etc/passwd /fakefile 2> ${ERR_FILE}
echo
echo "content of error file"
cat ${ERR_FILE}

#redirect STDOUT and STDERR to a file
head -n3 /etc/passwd /fakefile &> ${FILE}
echo
echo "Contents of ${FILE}:"
cat ${FILE}

#Redirect STDOUT and STDERR through a pipe
echo 
echo "content of stdout and stderr through pipe"
head -n3 /etc/passwd /fakefile |& cat -n

#send output to STDERR
echo "This is STDERR!" >&2

#Discarding stdout
echo
echo "Discarding STDOUT: "
head -n3 /etc/passwd /fakefile > /dev/null

#discard STDERR
echo
echo "Discarding STDERR:"
head -n3 /etc/passwd /fakefile 2> /dev/null

#discard both stdout and stderr
echo
echo "Discarding STDERR and STDOUT:"
head -n3 /etc/passwd /fakefile &> /dev/null

#clean up
rm ${FILE} ${ERR_FILE} &> /dev/null






