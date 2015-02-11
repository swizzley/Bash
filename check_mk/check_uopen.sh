#!/bin/bash
if [ "$#" -ne 2 ]
then
  echo "Usage: ./check_uopen.sh <user> <param>"
  echo "example ./check_uopen.sh tomcat nproc"
  echo "Valid Parameters are:
        - nproc - max number of processes
        - nofile - max number of open files"
  exit 1
fi

USER=$1
TYPE=$2

PROC="nproc"
FILE="nofile"

if [ "$TYPE" != "$PROC" ] && [ "$TYPE" != "$FILE" ]
then
  echo "Valid Parameters are:
        - nproc - max number of processes
        - nofile - max number of open files"
  exit 1
fi

if id $USER|grep -q [0-9];then

FNUM=$(lsof -u $USER |wc -l)
PNUM=$(ps aux|grep ^$USER|grep -v grep|wc -l)

LIMIT=4096

PLIM=$(sudo -u $USER bash -c "echo $(ulimit -u -H)")
FLIM=$(sudo -u $USER bash -c "echo $(ulimit -n -H)")

if [ "$TYPE" == "$PROC" ]; then
        LIMIT=$PLIM
else
        LIMIT=$FLIM
fi


PCURRENT=$(echo $PNUM/$LIMIT |bc -l)
FCURRENT=$(echo $FNUM/$LIMIT |bc -l)

WARN=0.90
CRIT=0.95

if [ "$TYPE" == "nproc" ]; then
        if [[ ${PCURRENT%.*} -gt ${CRIT%.*} ]];then
                echo "CRITICAL $USER has $PNUM processes running!"
                exit 1
        elif [[ ${PCURRENT%.*} -gt ${WARN%.*} ]];then
                echo "WARNING $USER has $PNUM processes running."
                exit 1
        else 
                echo "OK $USER has $PNUM processes running."
        fi
fi      

if [ "$TYPE" == "nofile" ]; then
        if [[ ${PCURRENT%.*} -gt ${CRIT%.*} ]];then
                echo "CRITICAL $USER has $FNUM files open!"
                exit 1
        elif [[ ${FCURRENT%.*} -gt ${WARN%.*} ]];then
                echo "WARNING $USER has $FNUM files open."
                exit 1
        else 
                echo "OK $USER has $FNUM files open."
        fi
fi

else
echo $USER not found
fi
                
