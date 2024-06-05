#!/bin/bash

set -e
set -x

# Run asset-import.sh asynchronously
./asset-import.sh &

# Optional: You may want to do something else while asset-import.sh runs in the background
# For example, you could log the start of the import process
echo -e "asset-import.sh script is running in the background...\n"

# Initiate APIGateway Startup 
echo -e "Starting APIGateway...\n"
/opt/softwareag/IntegrationServer/bin/startContainer.sh