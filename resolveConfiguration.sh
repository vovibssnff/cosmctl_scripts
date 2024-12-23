#!/bin/bash

cat /opt/cloud/environment.template | envsubst > /opt/cloud/environment.tmp

ENV_SUFFIX=""
if [ "$PREFIX" == "local" ]
then
	ENV_SUFFIX=".local"
fi

cat /opt/cloud/environment.template$ENV_SUFFIX | envsubst > /opt/cloud/environment.tmp

source /opt/cloud/environment.tmp
source /opt/cloud/configResolver.sh

if [ -f "/opt/cloud/environment" ]
then
	rm /opt/cloud/environment
	touch /opt/cloud/environment
fi

echo "$VARIABLE_PREFIX"

set | grep "$PROJECT" | sed 's|\([A-Za-z]*\)=.*|\1|' | while read varName
do
	echo "Value for $varName is ${!varName}"
	VALUE=${!varName}
	if [[ $VALUE = vault://* ]]
	then
		echo "Value is vault-based"
		IFS=':' read -ra PARTS <<< "$VALUE"
		SECRET=`echo ${PARTS[1]} | sed 's|//||g'`
		PROPERTY=${PARTS[2]}
		echo "Secret is $SECRET"
		echo "Property is $PROPERTY"
		RESOLVED_VALUE=`resolveConfig "$SECRET" "$PROPERTY"`
		echo "Resolved value: ${RESOLVED_VALUE:0:3}***************"
		echo ""
		echo "export $varName=$RESOLVED_VALUE" >> /opt/cloud/environment
	else
		echo "Preserving value: ${VALUE:0:3}***************"
		echo ""
		echo "export $varName=\"$VALUE\"" >> /opt/cloud/environment
	fi
done

. /opt/cloud/environment

