#!/bin/bash
##################
#
#	check_oildex_worker_services.sh
#
#	This Script is to parse results from the oildex-worker status page
#			dmorgan@oildex.com 11/18/2014
#
#	Dependencies: 52383 Nov 17 22:15 worker_services3.jmx
#	
#	Usage: mrpe script return OK, CRITICAL, UNKNOWN
#
#	Arguments: $1 = Service
#
###################
PID=/root/check_ows.run
if -f $PID then kill -9 $(cat $PID); fi
echo $$ > $PID
CHILD=$(ps aux|grep -v grep|grep "java"|grep "worker_services3.jmx"|awk -F " " '{print $2}')

CHECK_SERVICE=$1

JMETER_PATH="/root/scripts/jmeter/bin"
WORKER_JMX="/root/worker_services3.jmx"
JMX_LOG="/root/worker-services.log"
RUN_LOG="/root/worker-services-meta.log"

STATUS_PAGE="/root/results_worker.log*.html"
SERVICE_STATUS="/root/worker_services.status"

GOOD_STATUS="/root/worker_services_bch02b.good"
STATUS=$(grep $SERVICE $SERVICE_STATUS)
GOOD=$(grep SERVICE GOOD_STATUS)

#---BEGIN---
cd $JMETER_PATH
RUN_JMX="/usr/bin/java -jar $JMETER_PATH/ApacheJMeter.jar -n -t $WORKER_JMX -l $JMX_LOG 2>&1 > $RUN_LOG"

#Get the status page
do $RUN_JMX; sleep 10;

#Kill the JVM if it fails to exit
while [ -n $CHILD ]; do
	if [ `grep "end of run" $RUN_LOG` ]; then killall -9 $CHILD; fi
done

#Parse the status page for service status
for i in {1..21}; do grep "services:$i:txtTaskName" $STATUS_PAGE; done | awk  -F '[<>]' '/<td / { gsub(/<b>/, ""); sub(/ .*/, "", $3); print $14","$22 } ' > $SERVICE_STATUS

#Check Status
if [ "$STATUS" != "$GOOD_STATUS" ]; then echo "CRITICAL $STATUS"; elif [ "$STATUS" != "$GOOD_STATUS" ]; then echo "OK $STATUS"; else echo "UNKNOWN $STATUS"; fi 


#Ensure only one status page exists
rm -f $STATUS_PAGE

#Clean run file
rm -f $PID

exit
