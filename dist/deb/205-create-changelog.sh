#!/bin/bash

source ./100-env.sh
source /etc/lsb-release 2> /dev/null

cd ${DEBUILD_BUILD_DIR}
cd ${DEBUILD_APP_NAME}

mkdir debian
git log --decorate --date=rfc --graph > debian/changelog-git

AUTHOR=
DATE=
CHANGELOG=changelog

cd debian
while read line
do
  if [[ "$line" =~ ^\*.*( |\()tag: ]]
  then
		TAGVERSION=$(echo "${line}" | sed 's/^.*tag:\s*\([0-9\.]*\).*/\1/')
		
		if [ -n "${AUTHOR}" ]
		then
			echo >> ${CHANGELOG}
			echo " -- ${AUTHOR}  ${DATE}" >> ${CHANGELOG}
			echo >> ${CHANGELOG}
		fi
		echo "${DEBUILD_APP_NAME} (${TAGVERSION}-1) ${DISTRIB_CODENAME}; urgency=low" >> ${CHANGELOG}
		echo >> ${CHANGELOG}
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
		if [ -z "${DATE}" ]
		then
			DATE=$(echo "${line}" | sed 's/^.*Date:\s*\(.*\)/\1/')
		fi
  fi

  if [[ "$line" =~ ^\|\ \ \  ]]
  then
		LOG=$(echo "${line}" | sed 's/^|\s*\(.*\)\s*/\1/')
		echo "  * ${LOG}" >> ${CHANGELOG}
  fi
  
done < changelog-git

echo  >> ${CHANGELOG}
echo " -- ${AUTHOR}  ${DATE}" >> ${CHANGELOG}

rm changelog-git

cd ..
cp debian/changelog ${DEBUILD_SCRIPT_DIR}/debian/
