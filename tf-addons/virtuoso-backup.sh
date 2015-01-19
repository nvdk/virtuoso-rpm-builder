#!/bin/bash

## configuration
VIRT_USER=${VIRT_USER:-"dba"}
VIRT_PASS=${VIRT_PASS:-"dba"}
BACKUPDIR="/var/lib/virtuoso/backup" # make sure this is in DirsAllowed in virtuoso.ini 
DAYS=7 # files older then x days will be removed from the backup dir

## functions
function createbackup {
	ISQL=`which isql-vt || which isql`
	BACKUPDATE=`date +%y%m%d-%H%M`
  	$ISQL -U $VIRTUSER -P $VIRTPASS <<ScriptDelimit
		backup_context_clear();
		exec('checkpoint);
		backup_online('virt_backup_$BACKUPDATE#',1500,0,vector('$BACKUPDIR'));
		exit;
ScriptDelimit
}

## program
mkdir -p $BACKUPDIR
createbackup
find $BACKUPDIR -mtime +$DAYS -print0 | xargs -0 rm 2> /dev/null
