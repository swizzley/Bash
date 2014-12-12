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
#	Arguments: $1 = $Service_Name
#
#	The file below is a dependancy and prerequisite
#	It cannot have the services that are two words
#	above services with one word that exist in other services
#	Service names are case and space sensitive
#
#	    eg: Invoice 
#	        Invoice Scanned
#
#	BAD eg: Invoice Scanned
#		Invoice
#
#	worker_services_bch02b.good: 
#
#	OildexDaemonTask,STOPPED
#	Invoice,RUNNING
#	Invoice Scanned,RUNNING
#	FieldTicket,RUNNING
#	GasBalance,STOPPED
#	IRS1099,STOPPED
#	Jib,STOPPED
#	Jib Scanned,STOPPED
#	Jib Relations,STOPPED
#	Owner Relations,STOPPED
#	Payout,STOPPED
#	Petro Connect,STOPPED
#	Production,STOPPED
#	Invoice Statement,STOPPED
#	Investment Statement,STOPPED
#	Investment Image,STOPPED
#	Refresh,STOPPED
#	Complete Invoice,RUNNING
#	Complete FieldTicket,STOPPED
#	Complete Checkstub,STOPPED
#	Complete Jib,STOPPED
#
###################

#Must Supply a Service to check as Argument
: ${1?"Example Usage: $0 Invoice Scanned"}

#Set our run files
RUN=$$
PID=/tmp/ows_run

#Kill old pid if last run failed to die
if [ -f $PID ]; then kill -9 $(cat $PID) 2>&1 > /dev/null; fi
echo $RUN > $PID

#Set our variables
SERVICE="$(for i in "$*"; do echo $i; done)"

JMETER_PATH="/root/scripts/jmeter/bin"
WORKER_JMX="/root/worker_services3.jmx"

JMX_LOG="/tmp/worker-services-log.$RUN"
RUN_LOG="/tmp/worker-services-meta-log.$RUN"

SERVICE_STATUS="/tmp/worker_services_status"
GOOD_STATUS="/root/worker_services_bch02b.good"
STATUS_PAGE="/tmp/ows_raw_html"

run_jmx () {

	#---BEGIN---
	cd $JMETER_PATH
	RUN_JMX="/usr/bin/java -jar $JMETER_PATH/ApacheJMeter.jar -n -t $WORKER_JMX -l $JMX_LOG"

	#Get the status page
	$RUN_JMX 2>&1 > $RUN_LOG

	#Wait for the JVM to finish running
	DONE=0
	while [ $DONE -ne 1 ]; do
	        if
                	grep "end of run" $RUN_LOG 2>&1 > /dev/null; then DONE=1;
        	fi
	done

	#Declare results
	RESULTS=$(ls -t /tmp/results_worker_log*.html|head -1)
	cp $RESULTS /tmp/ows_raw_html

	#Parse the status page for service status
	for i in {1..21}; do grep "services:$i:txtTaskName" $STATUS_PAGE; done | awk  -F '[<>]' '/<td / { gsub(/<b>/, ""); sub(/ .*/, "", $3); print $14","$22 } ' > $SERVICE_STATUS
	rm -f /tmp/*.html

}

#Condition to avoid check_mk timeouts
if [ -a $STATUS_PAGE ]; then
  if test "`find $STATUS_PAGE -mmin +1`"; then
	run_jmx
  fi
fi
if [ ! -f $STATUS_PAGE ]; then
	run_jmx
fi
#End Timeout Condition


STATUS=$(grep -F "$SERVICE" $SERVICE_STATUS|head -1)
GOOD=$(grep -F "$SERVICE" $GOOD_STATUS|head -1)

#Check Status
OK_STATUS=$(echo $STATUS|awk -F "," '{print $2}')
if [ -z $OK_STATUS ]; then echo "UNKNOWN SERVICE NOT FOUND!"; elif [ "$STATUS" != "$GOOD" ]; then echo "CRITICAL $STATUS"; elif [ "$STATUS" == "$GOOD" ]; then echo "OK $SERVICE $OK_STATUS"; else echo "UNKNOWN $STATUS"; fi 

#Clean up files
rm -f $PID 
rm -f $JMX_LOG 
rm -f $RUN_LOG  

#Reap it
exit 0
