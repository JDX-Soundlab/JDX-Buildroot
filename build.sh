echo "We out here building our root & rocking our kernel..."

sudo systemctl start docker
sudo docker build -t jdxbuildroot .

TOTAL_RAM=$(grep MemTotal /proc/meminfo | awk '{print $2}')
DEFAULT_ALLOCATED_RAM=$(( (TOTAL_RAM / 1024) - 6144 ))
echo
echo "Default allocated RAM: ${DEFAULT_ALLOCATED_RAM} MB"
read -p "Enter custom RAM allocation in GB (or press Enter to use default): " CUSTOM_RAM_GB

if [[ -z "$CUSTOM_RAM_GB" ]]; then
    ALLOCATED_RAM=$DEFAULT_ALLOCATED_RAM
else
    ALLOCATED_RAM=$(( CUSTOM_RAM_GB * 1024 ))
fi

DEFAULT_SWAP=10240  # Default swap in MB (10GB)
echo
echo "Default swap size: $((DEFAULT_SWAP / 1024)) GB"
read -p "Enter custom swap size in GB (or press Enter to use default): " CUSTOM_SWAP_GB

if [[ -z "$CUSTOM_SWAP_GB" ]]; then
    ALLOCATED_SWAP=$DEFAULT_SWAP
else
    ALLOCATED_SWAP=$(( CUSTOM_SWAP_GB * 1024 ))
fi

TOTAL_CORES=$(nproc)
echo
echo "Default core limit: ${TOTAL_CORES} cores"
read -p "Enter custom core limit (or press Enter to use default): " CUSTOM_CORES

if [[ -z "$CUSTOM_CORES" ]]; then
    ALLOCATED_CORES=$TOTAL_CORES
else
    ALLOCATED_CORES=$CUSTOM_CORES
fi

echo
echo "Allocated RAM: ${ALLOCATED_RAM} MB"
echo "Allocated Swap: ${ALLOCATED_SWAP} MB"
echo "Allocated Cores: ${ALLOCATED_CORES}"

sudo docker run -it --memory="${ALLOCATED_RAM}m" --memory-swap="$((ALLOCATED_RAM + ALLOCATED_SWAP))m" --cpus="${ALLOCATED_CORES}" jdxbuildroot
