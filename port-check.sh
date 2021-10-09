#!/bin/bash

heliumPort=44158
localPublicIp=`curl -s "https://api.ipify.org"`

if [[ $localPublicIp =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
  echo "Found local IP $localPublicIp"
else
  echo "Unable to get local IP"
  exit 1
fi

if ! nmap $PARENTS_HOME_IP -p $heliumPort | grep open; then
  errorMessage="Unable to ping parent's house on Helium port $heliumPort"
  echo errorMessage
  curl -X POST -H 'Content-type: application/json' --data '{"text":"'"$errorMessage"'"}' $HELIUM_MONITOR_BOT_SLACK_WEBHOOK
fi

if ! nmap $localPublicIp -p $heliumPort | grep open; then
  errorMessage="Unable to ping my house on Helium port $heliumPort"
  echo errorMessage
  curl -X POST -H 'Content-type: application/json' --data '{"text":"'"$errorMessage"'"}' $HELIUM_MONITOR_BOT_SLACK_WEBHOOK
fi
