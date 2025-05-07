#!/bin/bash
#set -euxo pipefail

# Set locale to C.UTF-8
export LC_ALL=C.UTF-8
export LANG=C.UTF-8

cat << "EOF"

Welcome to the JDX Buildroot Environment!

    /$$$$$ /$$$$$$$  /$$   /$$        /$$$$$$                                      /$$ /$$                 /$$      
   |__  $$| $$__  $$| $$  / $$       /$$__  $$                                    | $$| $$                | $$      
      | $$| $$  \ $$|  $$/ $$/      | $$  \__/  /$$$$$$  /$$   /$$ /$$$$$$$   /$$$$$$$| $$        /$$$$$$ | $$$$$$$ 
      | $$| $$  | $$ \  $$$$/       |  $$$$$$  /$$__  $$| $$  | $$| $$__  $$ /$$__  $$| $$       |____  $$| $$__  $$
 /$$  | $$| $$  | $$  >$$  $$        \____  $$| $$  \ $$| $$  | $$| $$  \ $$| $$  | $$| $$        /$$$$$$$| $$  \ $$
| $$  | $$| $$  | $$ /$$/\  $$       /$$  \ $$| $$  | $$| $$  | $$| $$  | $$| $$  | $$| $$       /$$__  $$| $$  | $$
|  $$$$$$/| $$$$$$$/| $$  \ $$      |  $$$$$$/|  $$$$$$/|  $$$$$$/| $$  | $$|  $$$$$$$| $$$$$$$$|  $$$$$$$| $$$$$$$/
 \______/ |_______/ |__/  |__/       \______/  \______/  \______/ |__/  |__/ \_______/|________/ \_______/|_______/ 

Bottom Text

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

# Load Kernel Archive : Can probably be removed.....
# echo "Archiving Kernel Sources..."
# git archive --format=tar.gz --output=rockchip-kernel-snapshot.tar.gz develop-4.4

# Update the kernel configuration
make olddefconfig

# Build Toolchain & Sources
echo "Building Toolchain..."
make toolchain
# echo "Building Sources.."
# make source

# Build Kernel
#echo "Building Kernel..."
#make V=2 linux

# Build RootFS
#echo "Building RootFS..."
make V=2

exec /bin/bash -i