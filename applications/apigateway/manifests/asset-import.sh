#!/bin/bash
set -e
set -x
# Initiate APIGateway Startup 
/opt/softwareag/IntegrationServer/bin/startContainer.sh

# Wait for APIGateway to complete the startup
while [ $(curl -sw '%{http_code}' "http://localhost:5555/rest/apigateway/health" -o /dev/null) -ne 200 ]; do
    sleep 2;
done 

# Proceed with the APIGateway asset import activity
# Base directory containing the APIs
BASE_DIR="/opt/softwareag/apigwassets/apis"

# Loop through each subdirectory in the base directory
for SUBDIR in "$BASE_DIR"/*; do
    if [ -d "$SUBDIR" ]; then
        # Get the subdirectory name
        SUBDIR_NAME=$(basename "$SUBDIR")
        
        # Create the zip file path inside the subdirectory
        ZIP_FILE="${SUBDIR}/${SUBDIR_NAME}.zip"
        
        # Create a zip file for the subdirectory contents
        (cd "$SUBDIR" && zip -r "$ZIP_FILE" ./*)
        
        # Invoke curl with the zipped subdirectory contents and check the status
        CURL_RESPONSE=$(curl --write-out "%{http_code}" --silent --output /dev/null \
        --location 'http://localhost:5555/rest/apigateway/archive?apis=*&overwrite=true&preserveAssetState=true' \
        --header 'Content-Type: multipart/form-data' \
        --header 'Accept: application/json' \
        --header 'Authorization: Basic QWRtaW5pc3RyYXRvcjptYW5hZ2U=' \
        --form "zipFile=@\"$ZIP_FILE\"")
        
        # Check if curl command was successful
        if [ "$CURL_RESPONSE" -ne 200 ]; then
            echo "Upload failed for $ZIP_FILE with status code $CURL_RESPONSE"
            exit 1
        fi
        
        # Remove the zip file after successful upload
        rm "$ZIP_FILE"
    fi
done