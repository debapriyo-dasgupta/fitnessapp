#!/bin/bash
# Load the utility functions
. pipeline/common.lib/utils/get-version.sh
# Navigate to the desired location
cd container-images/
# Create the image using the docker file defined
echo "Listing existing images in the docker hosted machine"
docker image ls

#Login to JFrog Repo / Docker
echo "Login to docker repository -> Docker Inc."
# Update this section
docker login -u kplogesh -p Dexter@123

# Install base
echo "Image build process -> Install base of SAG Product - MSR"
read VERSION IMAGE_NAME < <(get-version "version.txt")

docker build -t install-base:${VERSION} -f Dockerfile-install-base .

# Install base tag and push
echo "Install base -> Image tagging"
docker image tag install-base:${VERSION} ${INSTALL_BASE_NAME}:${VERSION}

echo "Fitness Assessments Image Push -> Docker Repository"
docker push ${INSTALL_BASE_NAME}:${VERSION}

# MSR base
echo "Image build process -> MSR base of SAG Product - MSR"
read VERSION IMAGE_NAME < <(get-version "version.txt")

docker build -t msr-base:${VERSION} -f Dockerfile-msr-base .

# Install base tag and push
echo "Install base -> Image tagging"
docker image tag msr-base:${VERSION} ${IMAGE_NAME}:${VERSION}

echo "Fitness Assessments Image Push -> Docker Repository"
docker push ${IMAGE_NAME}:${VERSION}

echo "Listing the images post the build process"
docker image ls

echo "Logout -> Docker Repository"
docker logout