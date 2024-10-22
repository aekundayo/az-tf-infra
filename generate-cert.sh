#!/bin/bash

# Define the app name
AppName="DigitalShowroom"

# Create the root certificate
openssl req -x509 -newkey rsa:2048 -sha256 -nodes -keyout "${AppName}RootCert.key" -out "${AppName}RootCert.crt" -subj "/CN=${AppName}RootCert" -days 365

# Create the child certificate
openssl req -new -newkey rsa:2048 -sha256 -nodes -keyout "${AppName}ChildCert.key" -out "${AppName}ChildCert.csr" -subj "/CN=${AppName}ChildCert"

# Sign the child certificate with the root certificate
openssl x509 -req -in "${AppName}ChildCert.csr" -CA "${AppName}RootCert.crt" -CAkey "${AppName}RootCert.key" -CAcreateserial -out "${AppName}ChildCert.crt" -days 365

