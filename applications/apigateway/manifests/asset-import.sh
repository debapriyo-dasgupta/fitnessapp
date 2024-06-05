#!/bin/bash
set -e
set -x

# Wait for APIGateway to complete the startup
while [ $(curl -sw '%{http_code}' "http://localhost:5555/rest/apigateway/health" -o /dev/null) -ne 200 ]; do
    echo "Waiting for API Gateway to be up and running"
    sleep 5
done 

# Proceed with the APIGateway asset import activity
# Base directory containing the APIs
BASE_DIR="/opt/softwareag/apigwassets/apis"

echo "Importing the APIGateway Assets..."
# Loop through each subdirectory in the base directory
for SUBDIR in "$BASE_DIR"/*; do
    if [ -d "$SUBDIR" ]; then
        # Get the subdirectory name
        SUBDIR_NAME=$(basename "$SUBDIR")
        
        echo "Importing the APIGateway Asset - ${SUBDIR}..."
        # Create the zip file path inside the subdirectory
        ZIP_FILE="${SUBDIR}/${SUBDIR_NAME}.zip"
        
        # Create a zip file for the subdirectory contents
        (cd "$SUBDIR" && zip -r "$ZIP_FILE" ./*)
        
        # Invoke curl with the zipped subdirectory contents and capture the output and status code
        RESPONSE=$(mktemp)
        STATUS_CODE=$(curl --write-out "%{http_code}" --silent \
        --location 'http://localhost:5555/rest/apigateway/archive?apis=*&overwrite=true&preserveAssetState=true' \
        --header 'Content-Type: application/zip' \
        --header 'Accept: application/json' \
        --header 'Authorization: Basic QWRtaW5pc3RyYXRvcjptYW5hZ2U=' \
        --data-binary "@$ZIP_FILE" \
        --output "$RESPONSE")
        
        # Output the response body
        cat "$RESPONSE"
        
        # Check if curl command was successful
        if [ "$STATUS_CODE" -ne 200 ]; then
            echo "Upload failed for $ZIP_FILE with status code $STATUS_CODE"
            rm "$RESPONSE"
            exit 1
        fi
        
        # Clean up
        rm "$RESPONSE"
        rm "$ZIP_FILE"
    fi
done

echo "APIGateway Assets imported successfully."
