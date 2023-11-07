#!/bin/bash
# Load the utility functions
. pipeline/common.lib/utils/get-version.sh
# Navigate to the desired location
cd applications/
# Create the image using the docker file defined
echo "Listing existing images in the docker hosted machine"
docker image ls

#Login to JFrog Repo / Docker
echo "Login to docker repository -> Docker Inc."
docker login -u kplogesh -p Dexter@123

# Fitness-Assessments
read VERSION IMAGE_NAME < <(get-version "assessments/version.txt")

echo "Fitness Assessments -> Image tagging"
docker image tag fitness-assessments:${VERSION} kplogesh/fitness-app:assessments-${VERSION}

echo "Fitness Assessments Image Push -> Docker Repository"
docker push kplogesh/fitness-app:assessments-${VERSION}

# Fitness-Challenges
read VERSION IMAGE_NAME < <(get-version "challenges/version.txt")

echo "Fitness Challenges -> Image tagging"
docker image tag fitness-challenges:${VERSION} kplogesh/fitness-app:challenges-${VERSION}

echo "Fitness Challenges Image Push -> Docker Repository"
docker push kplogesh/fitness-app:challenges-${VERSION}

# Fitness-memberships
read VERSION IMAGE_NAME < <(get-version "memberships/version.txt")

echo "Fitness memberships -> Image tagging"
docker image tag fitness-memberships:${VERSION} kplogesh/fitness-app:memberships-${VERSION}

echo "Fitness memberships Image Push -> Docker Repository"
docker push kplogesh/fitness-app:memberships-${VERSION}

# Fitness-points
read VERSION IMAGE_NAME < <(get-version "points/version.txt")

echo "Fitness points -> Image tagging"
docker image tag fitness-points:${VERSION} kplogesh/fitness-app:points-${VERSION}

echo "Fitness points Image Push -> Docker Repository"
docker push kplogesh/fitness-app:points-${VERSION}

# Fitness-rewards
read VERSION IMAGE_NAME < <(get-version "rewards/version.txt")

echo "Fitness rewards -> Image tagging"
docker image tag fitness-rewards:${VERSION} kplogesh/fitness-app:rewards-${VERSION}

echo "Fitness rewards Image Push -> Docker Repository"
docker push kplogesh/fitness-app:rewards-${VERSION}


echo "Listing the images post the build process"
docker image ls

echo "Logout -> Docker Repository"
docker logout