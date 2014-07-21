#!/bin/bash

source ./100-env.sh


cd ${RPM_BUILD_DIR}
cd ${RPM_APP_NAME}

GITLOG=/tmp/${RPM_APP_NAME}-gitlog.log
git log --decorate --date=raw --graph > ${GITLOG}

SPEC=${RPM_APP_NAME}.spec


cd ..
cd ..

sed -i '/^%changelog/,$d' ${SPEC}

echo "%changelog" >> ${SPEC}



AUTHOR=
DATE=
TAGVERSION=
COUNTER=

while read line
do
  if [[ "$line" =~ ^\*.*( |\()tag: ]]
  then
		TAGVERSION=$(echo "${line}" | sed 's/^.*tag:\s*\([0-9\.]*\).*/\1/')	
		AUTHOR=
		DATE=
  fi

  if [[ "$line" =~ ^\|\ Author: ]]
  then
		if [ -z "${AUTHOR}" ]
		then
			AUTHOR=$(echo "${line}" | sed 's/^.*Author:\s*\(.*\)/\1/')
		fi
  fi

  if [[ "$line" =~ ^\|\ Date: ]]
  then
		if [ -z "${DATE}" ] && [ -n "${TAGVERSION}" ]
		then
			DATE=$(echo "${line}" | sed 's/^.*Date:\s*\(.*\)/\1/' | sed -E 's/\s.*//' | date -d - +"%a %b %d %Y")
			
			if [ -n "${COUNTER}" ]
			then
				echo >> ${SPEC}
			fi
			
			COUNTER="1"			
			echo "* ${DATE} ${AUTHOR} ${TAGVERSION}" >> ${SPEC}		
		fi
  fi

  if [[ "$line" =~ ^\|\ \ \  ]] && [ -n "${TAGVERSION}" ]
  then
		LOG=$(echo "${line}" | sed 's/^|\s*\(.*\)\s*/\1/')
		echo "- ${LOG}" >> ${SPEC}
  fi
  
done < ${GITLOG}
