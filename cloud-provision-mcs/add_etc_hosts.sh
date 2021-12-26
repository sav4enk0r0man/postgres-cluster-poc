#!/usr/bin/env bash

set -o errexit
set -o pipefail

DOMAIN="public"

ip_map=$(terraform state pull | jq '[(.["resources"][] | select(.name == "postgres_instance")["instances"][]["attributes"]) as $instance | (.["resources"][] | {name: $instance.name, fip: select(.name == "postgres_fip")["instances"][]["attributes"]["floating_ip"], id: select(.name == "postgres_fip")["instances"][]["attributes"]["instance_id"]}) | select(.id == $instance["id"])]')

echo ${ip_map} | jq -c -r '.[] | .name' | while read name
do
	fip=$(echo ${ip_map} | jq -c -r ".[] | select(.name == \"${name}\") | .[\"fip\"]")
	if [ "${DOMAIN}" != "" ]
	then
		name="${name}.${DOMAIN}"
	fi
	sudo sed -i "s/.*${name}/${fip}\t${name}/g" /etc/hosts
	echo "Replace ${name} to ${fip} in /etc/hosts"
	echo "Remove ${name} from ssh known hosts"
	ssh-keygen -R ${name}
done

#cat /etc/hosts

