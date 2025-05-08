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
destination_path="./config_copy"

# Check if a file named .config already exists in the destination path
if [ -f "${destination_path}" ]; then
    mv "${destination_path}" "${destination_path}old"
    echo "Existing file renamed to ${destination_path}old."
fi

# Copy the file from the container to the host
docker cp "${container_id}:${source_file}" "${destination_path}"

# Check if the copy was successful
if [ $? -eq 0 ]; then
    echo "File copied successfully to ${destination_path}."
else
    echo "Failed to copy the file."
    exit 1
fi