# README 

## Overview 
This codebase deploys a Multi-Perspective Issuance Corroboration (MPIC) implementation on Microsoft Azure in 39 datacenter locations.

## MPIC Deployment Setup 
1. **Download Azure CLI and clone this repo**
    - Make note of your subscription ID
2.  **Create Terraform resources**
    - Run the following line to deploy the necessary resources:
      ```bash
        terraform init -upgrade
      ```
      ```bash
        terraform plan -out main.tfplan
        terraform apply main.tfplan
      ```
    - If the given VM sizes are not available in certain regions, add the locations to the diff_regions list in main.tf and edit the backup_size variable as needed. 
3.  **Update URLs in deploy.sh**
    - From the terraform output, copy the public IPs list and re-format it to include colons and commas. In convert_pub_ips.py, replace the region_ips with this edited output and run the line:
      ```bash
        python convert_pub_ips.py
      ```
    - Copy this output to VM_IPS in deploy.sh and run:
      ```bash
        chmod +x deploy.sh
      ```
4.  **Copy the SSH private key (Terraform output) to private_key.pem**
    - After copying the key, run: 
      ```bash
        chmod 600 private_key.pem 
      ```
5.  **Upload the Flask app to the VMs**
    - Run the following line:
      ```bash
        bash deploy.sh
      ```

## How to run DCV 
Run the following command to execute DCV on a given domain (here example.com is used) 
```bash
  curl -X POST [INSERT US-EAST1 VM URL HERE]/run-all -H "Content-Type: application/json" -d '{"domain": "example.com"}’
```
  - Optional Query Parameters
    - "token": unique token to track http request in logs  
    - "node_a": unique identifier of the first node (used to track any errors during attacks) 
    - "node_b": unique identifier of the second node (used to track any errors during attacks)

## Logging 
Within the central VM (us-east1), you can track all attacks through the test_error (internal server errors) and test_summary (all dcv requests) folders. 
  - All attacks are logged in the format "{node_a}_{node_b}.log"


## MPIC Deployment Removal 
Run the following command to remove the 7 VM instances
```bash
  terraform plan -destroy -out main.destroy.tfplan
  terraform apply main.destroy.tfplan
```
