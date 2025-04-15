#!/bin/bash

# Set Azure subscription (replace with your actual subscription ID)
SUBSCRIPTION_ID="[REPLACE WITH YOUR SUBSCRIPTION ID]"
az account set --subscription $SUBSCRIPTION_ID

# Define VMs and their corresponding regions and IPs (using the new names)
# declare -A VMS_REGIONS
declare -A VMS_IPS

# VMS_REGIONS=(
#   ["vm-asia-east"]="East Asia"
#   ["vm-asia-southeast"]="Southeast Asia"
#   ["vm-australia-central"]="Australia Central"
# )

# Replace with the public IP addresses of your VMs
VMS_IPS=(
["vm-asia-east"]="52.175.39.181"
["vm-asia-southeast"]="52.163.118.152"
["vm-australia-central"]="20.28.19.238"
["vm-australia-east"]="20.191.232.6"
["vm-australia-southeast"]="13.77.0.172"
["vm-brazil-south"]="104.41.31.138"
["vm-canada-central"]="4.206.43.128"
["vm-europe-north"]="40.69.5.143"
["vm-europe-west"]="52.137.53.146"
["vm-france-central"]="40.89.171.185"
["vm-germany-westcentral"]="131.189.118.142"
["vm-india-central"]="4.247.164.80"
["vm-india-south"]="13.71.112.212"
["vm-indonesia-central"]="70.153.184.222"
["vm-israel-central"]="20.217.201.12"
["vm-italy-north"]="72.146.22.114"
["vm-japan-east"]="74.176.197.58"
["vm-japan-west"]="40.74.132.9"
["vm-korea-central"]="20.39.201.177"
["vm-mexico-central"]="158.23.92.31"
["vm-newzealand-north"]="172.204.93.77"
["vm-norway-east"]="51.107.213.251"
["vm-poland-central"]="20.215.244.8"
["vm-southafrica-north"]="4.221.59.84"
["vm-spain-central"]="68.221.142.83"
["vm-sweden-central"]="20.240.234.230"
["vm-switzerland-north"]="51.103.183.56"
["vm-uae-north"]="4.161.39.99"
["vm-uk-south"]="4.234.200.177"
["vm-uk-west"]="20.117.56.63"
["vm-us-central"]="40.122.71.63"
["vm-us-east"]="52.168.70.48"
["vm-us-east2"]="135.119.138.18"
["vm-us-northcentral"]="20.25.201.36"
["vm-us-southcentral"]="104.214.102.190"
["vm-us-west"]="172.184.200.7"
["vm-us-west2"]="13.66.218.23"
["vm-us-west3"]="20.163.70.18"
["vm-us-westcentral"]="52.161.165.215"
)

# Path to the Flask app (assumes app.py is in the same directory as this script)
APP_FILE="app.py"
APP_CENTRAL_FILE="app_central.py"

# Path to your SSH private key
PRIVATE_KEY_PATH="private_key.pem"  # Path to your private key file
USERNAME="azureadmin"  # Username on the VM

# Check if files exist
if [ ! -f "$APP_FILE" ]; then
  echo "Error: $APP_FILE not found!"
  exit 1
fi 

if [ ! -f "$APP_CENTRAL_FILE" ]; then
  echo "Error: $APP_CENTRAL_FILE not found!"
  exit 1
fi

# Loop through each VM, transfer the app.py file, and run the Flask app concurrently
for INSTANCE_NAME in "${!VMS_IPS[@]}"; do
    VM_IP=${VMS_IPS[$INSTANCE_NAME]}  # Get the IP address for the VM
    (
        echo "Starting setup for $INSTANCE_NAME in region $REGION (IP: $VM_IP)"

        # Kill any existing Flask processes on the VM (via SSH)
        echo "Killing any existing Flask processes on $INSTANCE_NAME..."
        ssh -o StrictHostKeyChecking=no -i $PRIVATE_KEY_PATH $USERNAME@$VM_IP "sudo pkill -f 'python3.*app.py'"
        sleep 2  # Optional: Add a short sleep to ensure the processes are properly killed

        # Transfer the correct Flask app file to the VM using SCP
        if [ "$INSTANCE_NAME" == "vm-us-east" ]; then
            echo "Transferring $APP_CENTRAL_FILE to $INSTANCE_NAME in region $REGION..."
            scp -o StrictHostKeyChecking=no -i $PRIVATE_KEY_PATH $APP_CENTRAL_FILE $USERNAME@$VM_IP:/tmp/
            ssh -o StrictHostKeyChecking=no -i $PRIVATE_KEY_PATH $USERNAME@$VM_IP "mv /tmp/$APP_CENTRAL_FILE /tmp/$APP_FILE"
        else
            echo "Transferring $APP_FILE to $INSTANCE_NAME in region $REGION..."
            scp -o StrictHostKeyChecking=no -i $PRIVATE_KEY_PATH $APP_FILE $USERNAME@$VM_IP:/tmp/
        fi

        # Run the new Flask app on the VM using SSH
        echo "Running Flask app on $INSTANCE_NAME..."
        ssh -o StrictHostKeyChecking=no -i $PRIVATE_KEY_PATH $USERNAME@$VM_IP "cd /tmp/ && nohup python3 $APP_FILE --host=0.0.0.0 &"

    ) &
done

# Wait for all background processes to finish
wait
