
echo "We out here building our root & rocking our kernel..."
sudo systemctl start docker
sudo docker build -t jdxbuildroot .
TOTAL_RAM=$(grep MemTotal /proc/meminfo | awk '{print $2}')
ALLOCATED_RAM=$(( (TOTAL_RAM / 1024) - 4096 ))
sudo docker run -it --memory="${ALLOCATED_RAM}m" jdxbuildroot
