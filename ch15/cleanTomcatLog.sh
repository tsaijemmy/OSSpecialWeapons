#!/bin/sh
# cleanTomcatLog.sh
find /opt/apache-tomcat-9.0.107/logs -type f -name "*.log" -mmin +180 -exec rm {} \;

