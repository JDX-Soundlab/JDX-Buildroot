#!/bin/bash
set -euxo pipefail

cat << "EOF"
The following build steps will be executed:
1. make olddefconfig
2. make toolchain
3. make V=1 linux

Continue Prompt
EOF

while true; do
    read -p "Proceed with build? (y/n): " continue_build
    case ${continue_build^^} in
        [Y]*) 
            echo "Starting build process..."
            break
            ;;
        [N]*) 
            echo "Dropping to interactive shell..."
            exec /bin/bash -i  # Replace current process with interactive shell
            ;;
        *) 
            echo "y or n"
            ;;
    esac
done

# Load Kernel Archive
# echo "Archiving Kernel Sources..."
# git archive --format=tar.gz --output=rockchip-kernel-snapshot.tar.gz develop-4.4

make olddefconfig

# Build Toolchain & Sources
echo "Building Toolchain..."
make toolchain
# echo "Building Sources.."
# make source

# Build Kernel
echo "Building Kernel..."
make V=2 linux

# Build RootFS
# echo "Building RootFS..."
# make buildroot