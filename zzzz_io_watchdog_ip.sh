#!/bin/bash
# Brouth to you by cttynul with love
# Check for more here https://github.com/cttynul

OLD_IP=$(cat ip.txt)
NEW_IP=$(wget -qO- http://ipecho.net/plain ; echo)

if [ "$NEW_IP" != "$OLD_IP" ]; then
        echo "IP should be updated!"
        curl "https://zzzz.io/api/v1/update/https://zzzz.io/api/v1/update/my_great_subdomain/?token=xxxxxxxx-XXXX-1010-0101-XXXXXXXXXXXX"
        echo $NEW_IP > ip.txt
else
        echo "No changes in your IP"
fi
