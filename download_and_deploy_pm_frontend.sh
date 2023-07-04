#!/bin/bash

# Download the docker-compose_frontend.yml file
rm -f /scripts/frontend/docker-compose.yml
curl -o /scripts/frontend/docker-compose.yml https://raw.githubusercontent.com/robertfraefel/pm_deployment/main/docker-compose_frontend.yml

# Check if the download was successful
if [ $? -eq 0 ]; then
  # Pull the latest images and check for updates
  PULL_RESULT=$(docker-compose -f /scripts/frontend/docker-compose.yml pull --quiet)

  if [ "$PULL_RESULT" != "" ]; then
    # Newer image available, recreate the containers
    docker-compose -f /scripts/frontend/docker-compose.yml up -d --force-recreate
  else
    # No newer image available, start the containers
    docker-compose -f /scripts/frontend/docker-compose.yml up -d
  fi

else
  echo "Failed to download the docker-compose_frontend.yml file."
fi
