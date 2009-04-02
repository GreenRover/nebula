#!/bin/bash

# Parameters
projectid="nebula.gallery"
version="0.5.0";
writableBuildRoot="$HOME/Documents/Nebula/build";
buildType="N"


buildTimestamp=`date +%Y%m%d%H%M`
if [[ ! $downloadsDir ]]; then downloadsDir="${writableBuildRoot}/downloads"; fi
if [[ ! $thirdPartyJarsDir ]]; then thirdPartyJarsDir="${writableBuildRoot}/3rdPartyJars"; fi
if [[ ! $buildDir ]]; then
	buildDir="${writableBuildRoot}/${projectid//.//}/downloads/drops/${version}/${buildType}${buildTimestamp}"
fi

startPath=".";
if [[  -f ${writableBuildRoot}/org.eclipse.dash.common.releng/tools/scripts/start_logger.sh ]]; then 
   startPath="${writableBuildRoot}/org.eclipse.dash.common.releng/tools/scripts";
fi

$startPath/start.sh -projectid $projectid  -version $version  -projRelengRoot ':pserver:anonymous@dev.eclipse.org:/cvsroot/technology'    -projRelengPath 'org.eclipse.swt.nebula/org.eclipse.nebula.widgets.gallery.releng' -javaHome $JAVA_HOME -writableBuildRoot $writableBuildRoot  -buildTimestamp $buildTimestamp
buildResult=$?

ls $buildDir/*

if [ "$buildResult" -ne "0" ]; then

      rm $buildDir/*Update*
      rm $buildDir/*Master*
      rm $buildDir/*ALL*

     rsync -aP $buildDir rnicolas@dev.eclipse.org:/home/data/httpd/download.eclipse.org/technology/nebula/downloads/drops/
     rsync -aP --list-only $buildDir/ rnicolas@dev.eclipse.org:/home/data/httpd/download.eclipse.org/technology/nebula/downloads/drops/latest/

	ls $buildDir/*
fi