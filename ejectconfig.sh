#!/bin/bash

# Get the newest running Docker container ID
container_id=$(docker ps --format "{{.ID}}" --latest)

# Check if a container was found
if [ -z "$container_id" ]; then
    echo "No running Docker containers found."
    exit 1
fi

# Define the source file path inside the container
source_file="/root/buildroot/.config"

# Define the destination path on the host
destination_path="./exported_config"

# Copy the file from the container to the host
docker cp "${container_id}:${source_file}" "${destination_path}"

# Check if the copy was successful
if [ $? -eq 0 ]; then
    echo "Configuration exported successfully to ${destination_path}."
else
    echo "Failed to export the configuration."
    exit 1
fi
