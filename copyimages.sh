#!/bin/bash

# Get the most recent Docker container ID (newest first by default)
container_id=$(docker ps -a --format "{{.ID}}" | head -n 1)

if [ -z "$container_id" ]; then
    echo "No Docker containers found."
    exit 1
fi

mkdir -p flashing/images

# Copy /buildroot/output/images from the container to flashing/images
docker cp "$container_id":root/buildroot/output/images/. flashing/images/

echo "Images copied to flashing/images"