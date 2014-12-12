#!/bin/bash


CHECK=$(/sbin/service logstash status)

if [ "$CHECK" == "logstash is running" ]; then echo OK $CHECK; else echo CRITICAL; fi
