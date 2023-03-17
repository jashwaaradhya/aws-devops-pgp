#!/bin/bash

sudo apt-get update
sudo docker build /home/ubuntu/aws-devops-pgp -t flaskapp
sudo docker run -it -p 85:80 -d --name flaskapp flaskapp
sudo docker login -u jashwa -p Jashkpit070!!
sudo docker commit flaskapp jashwa/flaskapp
sudo docker push jashwa/flaskapp
sudo docker rm -vf $(sudo docker ps -aq)
sudo docker rmi -f $(sudo docker images -aq)
aws eks update-kubeconfig --region us-west-2 --name Final
