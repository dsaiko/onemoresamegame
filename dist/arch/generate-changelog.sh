#!/bin/bash


PKGNAME=$(cat PKGBUILD | grep pkgname= | sed 's/^pkgname=//')

GITLOG=/tmp/${PKGNAME}-changelog-git

git log --decorate --date=iso --graph > ${GITLOG}

AUTHOR=
DATE=
TAGVERSION=
COUNTER=

CHANGELOG=${PKGNAME}.changelog
rm ${CHANGELOG} 2>/dev/null

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
			DATE=$(echo "${line}" | sed 's/^.*Date:\s*\(.*\)/\1/' | sed -E 's/\s.*//')
			
			if [ -n "${COUNTER}" ]
			then
				echo >> ${CHANGELOG}
			fi
			
			echo ${DATE} ${AUTHOR} >> ${CHANGELOG}
			echo >> ${CHANGELOG}
			echo "     * ${TAGVERSION} :" >> ${CHANGELOG}
		
			COUNTER="1"
		fi
  fi

  if [[ "$line" =~ ^\|\ \ \  ]] && [ -n "${TAGVERSION}" ]
  then
		LOG=$(echo "${line}" | sed 's/^|\s*\(.*\)\s*/\1/')
		echo "	${LOG}" >> ${CHANGELOG}
  fi
  
done < ${GITLOG}
