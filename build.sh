
echo "We out here building our root & rocking our kernel..."
sudo docker build -t jdxbuildroot .
sudo docker run -it jdxbuildroot
