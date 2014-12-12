#!/bin/bash
# check-adapter Script to check status of the adapter appliance
## set user name
TERM=xterm
export TERM
USER=`whoami`
## set Application User list
#APP_USER="adptprod"
#APP_USER="adptprod adpttest"
## set Appliance name
#SYS_NAME=`uname -n |awk 'BEGIN {FS="." }{print $1}'`
#
##### Check mounts #####
#
check_mounts ()
{
clear
#echo -e "\n\n\t\t Checking mounts "
for APP_USER in adptprod adpttest
do
        REPUTED_MOUNTS=`grep -v "^#" /etc/rc.local|grep -o $APP_USER`
        EXISTING_MOUNTS=`mount |grep -o $APP_USER`

        if [[ "$REPUTED_MOUNTS" != "$EXISTING_MOUNTS" ]] ; then
                echo -e "\n\t\t Mounts for $APP_USER do not match"
        else
                echo -e "\n\t\t Mounts for $APP_USER are OK"
        fi
done

}

                #check_mounts;\
                MNT_STATUS=`check_mounts |grep -o match |head -1`
                if [[ $MNT_STATUS == match ]]; then
                        echo -e "CRITICAL - Mounts are missing ! | status=-1 \c"
                        exit 2
                else
                        echo -e "OK - Mounts look fine | status=1 \c"
                        exit 0
                fi ;