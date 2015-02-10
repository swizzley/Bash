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

LIMIT=1024

SLIM=$(grep $USER /etc/security/limits.conf|grep soft|grep $TYPE|awk -F " " '{print $4}')
HLIM=$(grep $USER /etc/security/limits.conf|grep hard|grep $TYPE|awk -F " " '{print $4}')

if [ ! -z "$SLIM" ];then 
        if [ "$SLIM" == "$HLIM" ]; then #echo "WTF! Why are hard n soft limits for $TYPE set the same?"
                LIMIT=$SLIM
        else
                LIMIT=$HLIM
        fi
fi

PCURRENT=$(echo $PNUM/$LIMIT |bc -l)
FCURRENT=$(echo $FNUM/$LIMIT |bc -l)

WARN=0.80
CRIT=0.90

if [ "$TYPE" == "nproc" ]; then
        if [[ ${PCURRENT%.*} -gt ${WARN%.*} ]];then
                echo "WARNING $USER has $PNUM processes running."
        elif [[ ${PCURRENT%.*} -gt ${CRIT%.*} ]];then
                echo "CRITICAL $USER has $PNUM processes running!"
        else 
                echo "OK $USER has $PNUM processes running."
        fi
fi      

if [ "$TYPE" == "nofile" ]; then
        if [[ ${FCURRENT%.*} -gt ${WARN%.*} ]];then
                echo "WARNING $USER has $FNUM files open."
        elif [[ ${PCURRENT%.*} -gt ${CRIT%.*} ]];then
                echo "CRITICAL $USER has $FNUM files open!"
        else 
                echo "OK $USER has $FNUM files open."
        fi
fi

else
echo $USER not found
fi
                
