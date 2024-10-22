#!/bin/bash

# Check for required arguments
if [[ $# -lt 3 ]]; then
    echo "Usage: $0 <FOLDER> <ROOT_CERT_NAME> <CLIENT_CERT_NAME>"
    exit 1
fi

FOLDER="$1"
ROOT_CERT_NAME="$2"
CLIENT_CERT_NAME="$3"

# Check if 'openssl' command is available
which openssl &> /dev/null || { echo "Error: 'openssl' command not found."; exit 1; }

# Generate the Root Certificate
openssl genpkey -algorithm RSA -out "${FOLDER}/${ROOT_CERT_NAME}.key" || { echo "Error generating root private key."; exit 1; }
openssl req -new -x509 -days 365 -key "${FOLDER}/${ROOT_CERT_NAME}.key" -out "${FOLDER}/${ROOT_CERT_NAME}.crt" -subj "/CN=${ROOT_CERT_NAME}" || { echo "Error generating root certificate."; exit 1; }

# Generate the Server Certificate with the proper EKU
echo "extendedKeyUsage = serverAuth" > "${FOLDER}/server.ext"
openssl genpkey -algorithm RSA -out "${FOLDER}/${ROOT_CERT_NAME}-server.key" || { echo "Error generating server private key."; exit 1; }
openssl req -new -key "${FOLDER}/${ROOT_CERT_NAME}-server.key" -out "${FOLDER}/${ROOT_CERT_NAME}-server.csr" -subj "/CN=${ROOT_CERT_NAME} Server"
openssl x509 -req -days 365 -in "${FOLDER}/${ROOT_CERT_NAME}-server.csr" -CA "${FOLDER}/${ROOT_CERT_NAME}.crt" -CAkey "${FOLDER}/${ROOT_CERT_NAME}.key" -set_serial 02 -out "${FOLDER}/${ROOT_CERT_NAME}-server.crt" -extfile "${FOLDER}/server.ext"

# Generate the Client Certificate with the proper EKU
echo "extendedKeyUsage = clientAuth" > "${FOLDER}/client.ext"
openssl genpkey -algorithm RSA -out "${FOLDER}/${CLIENT_CERT_NAME}.key" || { echo "Error generating client private key."; exit 1; }
openssl req -new -key "${FOLDER}/${CLIENT_CERT_NAME}.key" -out "${FOLDER}/${CLIENT_CERT_NAME}.csr" -subj "/CN=${CLIENT_CERT_NAME}"
openssl x509 -req -days 365 -in "${FOLDER}/${CLIENT_CERT_NAME}.csr" -CA "${FOLDER}/${ROOT_CERT_NAME}.crt" -CAkey "${FOLDER}/${ROOT_CERT_NAME}.key" -set_serial 03 -out "${FOLDER}/${CLIENT_CERT_NAME}.crt" -extfile "${FOLDER}/client.ext"

# Cleanup
rm "${FOLDER}/server.ext" "${FOLDER}/client.ext" "${FOLDER}/${ROOT_CERT_NAME}-server.csr" "${FOLDER}/${CLIENT_CERT_NAME}.csr"
chmod 644 "${FOLDER}/${CLIENT_CERT_NAME}.key" "${FOLDER}/${ROOT_CERT_NAME}.key" "${FOLDER}/${ROOT_CERT_NAME}-server.key"
echo "Certificates generated successfully!"
