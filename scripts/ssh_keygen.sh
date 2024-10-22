#!/bin/bash

# Define where to save the SSH key
key_path="$1"
key_name="$2"

# Create directory if not exists
mkdir -p $key_path

# Generate the key
ssh-keygen -t rsa -b 4096 -f $key_path/$key_name

# Change the permissions of the private key file so only you can access it
chmod 444 $key_path/$key_name

echo "SSH key pair has been generated and saved in $key_path/$key_name"
