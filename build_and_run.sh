#!/bin/bash
# This script is created by fgata-va from 42Madrid just cause lazyness.
# With this script, you'll be able to build your image from your dockerfile in the case it's not created, download de Wordpress files (if you already have them and don't wanna loose your page data don't change the name of the directory) and run the container made from your ft_service image

# Before execute edit this values with your container desired name and your desired image tag
NAME=test_01
TAG=test:v0.3

echo -e "\nYour image will have the tag: \e[38;5;208m$TAG \n"
echo -e "\e[39mand your container will have the name: \e[38;5;208m$NAME \n"
echo -e "\e[39m"
if [ ! -d "wordpress" ]; then
	curl -LO https://wordpress.org/latest.tar.gz
	tar xzvf latest.tar.gz
	rm -f latest.tar.gz
fi
if [[ "$(docker image inspect -f='{{.RepoTags}}' $TAG)" == "" ]]; then
	docker build -t=$TAG $PWD
	if [ $? -eq 0 ]; then
		echo -e "\n\n\e[32mBuild successful"
	else
		echo -e "\n\n\e[91mError in the build"
	fi
else
	echo -e "\n\n\e[32mImage exists"
fi
if [ ! "$(docker ps -q -f name=$NAME)" ]; then
    if [ "$(docker ps -aq -f status=exited -f name=$NAME)" ]; then
		echo -e "\n\n\e[32mDeleting old container..."
		docker rm $NAME
    fi
	echo -e "\n\n\e[32mRuning the container..."
    docker run -it -d \
	-v $PWD/wordpress:/var/www/html/wordpress -p 80:80 -p 443:443 --name=$NAME $TAG
else
	echo "\n\n\e[91mStop the container $NAME to start again"
fi
