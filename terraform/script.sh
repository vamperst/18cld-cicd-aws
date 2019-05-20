#!/bin/bash

# sleep until instance is ready
until [[ -f /var/lib/cloud/instance/boot-finished ]]; do
  sleep 1
done

# install nginx
apt-get update -y
curl -Ssl https://get.docker.com | sh
sudo groupadd docker
sudo usermod -aG docker $USER
sudo systemctl restart docker

sudo apt-get install jq -y
name=$(cat /tmp/imagedefinitions.json | jq '.[] .name')
imageUri=$(cat /tmp/imagedefinitions.json | jq '.[] .imageUri')

export LC_ALL="en_US.UTF-8"
export LC_CTYPE="en_US.UTF-8"
sudo locale-gen "en_US.UTF-8"
sudo pip3 install awscli
sudo apt install awscli
login=$(aws ecr get-login)
login=$(echo $login | sed 's/-e none/ /g' | tee)
echo $login | bash

docker run -d -p 3000:3000 --restart on-failure $imageUri
echo "Deployed $imageUri =)"




