#!/bin/bash
# 
# Plugin to check processes running
#
##########################################################
case $1 in
  --help | -h )
        echo "Usage: check_proc_by_user [proc] [min] [max] [user]"
        echo " [min] and [max] as int"
        echo " Example: check_proc_by_user java 1 5 weblogic"
         exit 3
         ;;
  * )
    ;;
esac

if [ ! "$1" -o ! "$2" -o ! "$3" ]; then
        echo "Usage: check_proc [proc] [min] [max]"
        echo " [min] and [max] as int"
        echo " Example: check_proc sshd 1 5"
        echo "Unknown: Options missing"
        exit 3
fi

if [ "$2" -gt "$3" ]; then
        echo "Unknown: [max] must be larger than [min]"
        exit 3
fi

proc=$1
min=$2
max=$3
name_length=$(echo $4|wc -c)

if [ "$name_length" -gt 21 ];then
user=$(id $4|awk -F "=" '{print $2}'|awk -F "(" '{print $1}')
else
user=$4
fi


lines=`ps ax -o user='-------------------',args|grep ^$user | grep $proc | grep -Ev 'grep|check_proc' | wc -l`

if [ "$lines" -eq "$min" -o "$lines" -gt "$min" ]; then
        if [ "$lines" -lt "$max" -o "$lines" -eq "$max" ]; then
                echo "OK: $user has $lines processe(s) running (min=$min, max=$max)"
                exit 0
         else
                echo "Critical: $user Has too many processes running (current/max) ($lines/$max)"
                exit 1
        fi
 elif [ "$lines" -lt "$min" ]; then
        echo "Critical: $user does not have enough processes running (current/min) ($lines/$min)"
        exit 2
 else
        echo "Unknown: error"
        exit 3
fi
