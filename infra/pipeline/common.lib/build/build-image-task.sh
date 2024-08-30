#!/bin/bash
# Load the utility functions
. infra/pipeline/common.lib/utils/get-version.sh
# Navigate to the desired location
cd applications/
# Create the image using the docker file defined
echo "Listing existing images in the docker hosted machine"
docker image ls

#Login to JFrog Repo / Docker
echo "Login to docker repository -> Docker Inc."

# Create APIGW image
docker login -u Logeshwaran-KannanPonnurangam-softwareag-com -p 7c+bAyjLvT+rY6pHSsZZvkH1opNMBGWKw6+RoLUx1X+ACRAyhh5s sagcr.azurecr.io
# Fitness-Apigateway
echo "Image build process -> APIGateway"
read VERSION IMAGE_NAME < <(get-version "apigateway/version.txt")

docker build -t fitness-apigateway:${VERSION} -f apigateway/Dockerfile .
docker logout
# End apigw image creation

# Update this section
docker login -u kplogesh -p Dexter@123

# Fitness-Assessments
echo "Image build process -> Fitness Assessments"
read VERSION IMAGE_NAME < <(get-version "assessments/version.txt")

docker build -t fitness-assessments:${VERSION} -f assessments/Dockerfile .
# Improvise this section to read the image name from config----

# Fitness-Challenges
echo "Image build process -> Fitness Challenges"
read VERSION IMAGE_NAME < <(get-version "challenges/version.txt")

docker build -t fitness-challenges:${VERSION} -f challenges/Dockerfile .
# Improvise this section to read the image name from config----

# Fitness-memberships
echo "Image build process -> Fitness memberships"
read VERSION IMAGE_NAME < <(get-version "memberships/version.txt")

docker build -t fitness-memberships:${VERSION} -f memberships/Dockerfile .
# Improvise this section to read the image name from config----

# Fitness-points
echo "Image build process -> Fitness points"
read VERSION IMAGE_NAME < <(get-version "points/version.txt")

docker build -t fitness-points:${VERSION} -f points/Dockerfile .
# Improvise this section to read the image name from config----

# Fitness-rewards
echo "Image build process -> Fitness rewards"
read VERSION IMAGE_NAME < <(get-version "rewards/version.txt")

docker build -t fitness-rewards:${VERSION} -f rewards/Dockerfile .
# Improvise this section to read the image name from config----

echo "Listing the images post the build process"
docker image ls

echo "Logout -> Docker Repository"
docker logout