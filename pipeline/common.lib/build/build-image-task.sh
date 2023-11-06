#!/bin/bash
# Load the utility functions
. pipeline/common.lib/utils/get-version.sh
# Navigate to the desired location
cd applications/
# Create the image using the docker file defined
echo "Listing existing images in the docker hosted machine"
df -h
docker image ls

#Login to JFrog Repo / Docker
echo "Login to docker repository -> Docker Inc."
docker login -u kplogesh -p Dexter@123

# Fitness-Assessments
echo "Image build process -> Fitness Assessments"
read VERSION IMAGE_NAME < <(get-version "assessments/version.txt")

docker build -t fitness-assessmens:${VERSION} -f assessments/Dockerfile .
# Improvise this section to read the image name from config----

echo "Fitness Assessments -> Image tagging"
docker image tag fitness-app:${VERSION} kplogesh/fitness-app/assessments:${VERSION}

echo "B2B Platinum Solution Image Push -> JFrog Image Repository"
docker push kplogesh/fitness-app/assessments:${VERSION}


echo "Listing the images post the build process"
docker image ls

echo "Logout -> Docker Repository"
docker logout