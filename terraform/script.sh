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


login=$(aws ecr get-login)
login=$(echo $login | sed 's/-e none/ /g' | tee)
echo $login | bash

docker run -d -p 3000:3000 --restart on-failure $imageUri
echo "Deployed $imageUri =)"




