#!/bin/bash
TERM=xterm
export TERM
USER=`whoami`
SYS_NAME=`uname -n |awk 'BEGIN {FS="." }{print $1}'`
##### Check Adaper Code Instance #####
#
check_instance ()
{
INSTANCE_PID=`ps auxwww |grep "$APP_USER" |grep oildex.adapter.Adapter |grep -v grep |awk '{print $2}'`

#echo $INSTANCE_PID;pause

#if [ $INSTANCE_PID -gt 0 ] ; then
if [ -n "$INSTANCE_PID" ] ; then
        echo -e "\n\n\n\t  $SYS_NAME, $APP_USER instance PID = $INSTANCE_PID"
else
        echo -e "\n\n\n\t ***** $SYS_NAME, $APP_USER instance PID not found  *****"
fi

}

                #Confirm connection
                #echo -e "connected:\c"
                #check instance
                APP_USER=adptprod; INST_PID=`check_instance|awk '{print $6}'`; \
                        if [[ $INST_PID -le 0 ]]; then
                                #echo -e "$INST_PID:\c"
                                echo -e "CRITICAL - adapter PID not found!| status=-1 \c"
                                exit 2
                        else
                                #echo -e "$INST_PID:\c"
                                echo -e "OK - adapter PID found | status=1 \c"
                                exit 0
                        fi;