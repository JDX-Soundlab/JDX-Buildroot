#!/bin/bash
set -euxo pipefail  # Exit on error, show commands

#Load Kernel Archive
# echo "Archiving Kernel Sources..."
# git archive --format=tar.gz --output=rockchip-kernel-snapshot.tar.gz develop-4.4

# Build Toolchain & Sources
echo "Building Toolchain..."
make toolchain
echo "Building Sources.."
make source

# Build Kernel
echo "Building Kernel..."
make linux

# Build RootFS
echo "Building RootFS..."
make buildroot