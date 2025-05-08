echo "We out here building our root & rocking our kernel..."
sudo systemctl start docker
sudo docker build -t jdxbuildroot .

TOTAL_RAM=$(grep MemTotal /proc/meminfo | awk '{print $2}')
DEFAULT_ALLOCATED_RAM=$(( (TOTAL_RAM / 1024) - 4096 ))

echo "Default allocated RAM: ${DEFAULT_ALLOCATED_RAM} MB"
read -p "Enter custom RAM allocation in GB (or press Enter to use default): " CUSTOM_RAM_GB

if [[ -z "$CUSTOM_RAM_GB" ]]; then
    ALLOCATED_RAM=$DEFAULT_ALLOCATED_RAM
else
    ALLOCATED_RAM=$(( CUSTOM_RAM_GB * 1024 ))
fi

sudo docker run -it --memory="${ALLOCATED_RAM}m" jdxbuildroot
