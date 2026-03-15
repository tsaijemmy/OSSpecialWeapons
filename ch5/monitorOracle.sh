#!/usr/bin/bash
DATE=`date +%Y%m%d`
LOG=/home/oracle12/logs/sblmon_${DATE}.log

if [ -f /home/oracle12/logs/lock ]; then	# If a file named "lock", then disable the scripts
	echo `date` >> $LOG
	echo "================================" >> $LOG
	echo "Oracle Monitoring Script Disabled" >> $LOG
fi

export smon=`ps -ef | grep -v grep | grep -c ora_smon_${ORACLE_SID}`
export lsnr=`ps -ef | grep -v grep | grep -c LISTENER`
export pmon=`ps -ef | grep -v grep | grep -c ora_pmon_${ORACLE_SID}`
export lgwr=`ps -ef | grep -v grep | grep -c ora_lgwr_${ORACLE_SID}`
export dbw0=`ps -ef | grep -v grep | grep -c ora_dbw0_${ORACLE_SID}`

export dbstatus=`sqlplus -s / as sysdba <<EOF
set heading off feedback off termout off;
select OPEN_MODE from v\\\$database;
exit;
EOF`

dbstatus=$(echo ${dbstatus:1})	# remove first character that is an extra special character)
echo $dbstatus
echo `date` >> $LOG

if [ $dbw0 -eq 0 ]; then
	echo "dbw0 failed" >> $LOG
	exit 1
elif [ $lsnr -eq 0 ]; then
	echo "lsnr failed" >> $LOG
	exit 1
elif [ $pmon -eq 0 ]; then
	echo "pmon failed" >> $LOG
	exit 1
elif [ $lgwr -eq 0 ]; then
	echo "lgwr failed" >> $LOG
	exit 1
elif [ $smon -eq 0 ]; then
	echo "smon failed" >> $LOG
	exit 1
elif [ "$dbstatus" != "READ WRITE" ]; then
	echo "DB OPEN_MODE is note READ WRITE" >> $LOG
	exit 1
else
	echo "Success" >> $LOG
	exit 0
fi
