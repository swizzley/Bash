#!/bin/bash

CHECK=$(/sbin/service elasticsearch status)
PID=$(ps -u 497|awk -F " " '{print $1}'|tail -1)
HIGH=$(ps -aux|grep $PID|grep -v grep|awk -F " " '{print $3}')

if [ $PID -gt 0 ]; then echo OK $CHECK; else echo CRITICAL; fi
