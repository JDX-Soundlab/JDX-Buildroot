#!/bin/bash

# Get the most recent Docker container ID
container_id=$(docker ps -a --format "{{.ID}}" --sort=created | head -n 1)

if [ -z "$container_id" ]; then
    echo "No Docker containers found."
    exit 1
fi

#mkdir -p flashing/images

# Copy /buildroot/output/images from the container to flashing/images
docker cp "$container_id":/buildroot/output/images/. flashing/images/

echo "Images copied to flashing/images."