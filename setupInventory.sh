#!/bin/bash

# Define container names
containers=("ansible-webserver-1-1" "ansible-webserver-2-1")

# Define the inventory file path
inventory_file="inventory.ini"

# Clear or create the inventory file and add the group header
echo "[webservers]" > $inventory_file

# Loop through each container, get its IP, and append to inventory file
for container in "${containers[@]}"; do
    ip_address=$(sudo docker inspect $container | jq -r '.[].NetworkSettings.Networks[].IPAddress')
    
    # Check if IP address is not empty
    if [[ -n "$ip_address" ]]; then
        echo "$container ansible_host=$ip_address" >> $inventory_file
    else
        echo "Failed to get IP address for $container"
    fi
done

echo "Ansible inventory updated!"
