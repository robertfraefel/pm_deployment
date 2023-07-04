#!/bin/bash

# Download the docker-compose.yml file
rm -f /scripts/backend/docker-compose.yml
curl -o /scripts/backend/docker-compose.yml https://raw.githubusercontent.com/robertfraefel/pm_deployment/main/docker-compose_backend.yml

# Check if the download was successful
if [ $? -eq 0 ]; then
  # Pull the latest images and check for updates
  PULL_RESULT=$(docker-compose -f /scripts/backend/docker-compose.yml pull --quiet)

  if [ "$PULL_RESULT" != "" ]; then
    # Newer image available, recreate the containers
    docker-compose -f /scripts/backend/docker-compose.yml up -d --force-recreate
  else
    # No newer image available, start the containers
    docker-compose -f /scripts/backend/docker-compose.yml up -d
  fi

else
  echo "Failed to download the docker-compose_backend.yml file."
fi
