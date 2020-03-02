#!/bin/bash
# This script is created by fgata-va from 42Madrid just cause lazyness.
# With this script, you'll be able to build your image from your dockerfile in the case it's not created, download de Wordpress files (if you already have them and don't wanna loose your page data don't change the name of the directory) and run the container made from your ft_service image

# Before execute edit this values with your container desired name and your desired image tag
NAME=wordpress
TAG=ft_server:v1
VOL_DIR= $(dirname $(pwd)) + "wordpress"

echo -e "\nYour image will have the tag: \e[38;5;208m$TAG \n"
echo -e "\e[39mand your container will have the name: \e[38;5;208m$NAME\e[39m\n"
if [ ! -d "../wordpress" ]; then
	curl -LO https://wordpress.org/latest.tar.gz
	tar xzvf latest.tar.gz -C ..
	rm -f latest.tar.gz
fi
echo -e "Image $TAG: "
if [[ "$(docker image inspect -f='{{.RepoTags}}' $TAG)" == "" ]]; then
	echo -e "\e[38;5;208mDoesn't exists. \e[39mBuilding...\n"
	docker build -t=$TAG ../../
	if [ $? -eq 0 ]; then
		echo -e "\n\n\e[32mBuild successful"
	else
		echo -e "\n\n\e[91mError in the build"
	fi
else
	echo -e "\e[32mExists\e[39m\n"
fi
if [ ! "$(docker ps -q -f name=$NAME)" ]; then
    if [ "$(docker ps -aq -f status=exited -f name=$NAME)" ]; then
		echo -e "\n\n\e[32mDeleting old container..."
		docker rm $NAME
    fi
	echo -e "\n\n\e[32mRunning the container..."
    docker run -it -d \
	-v $VOL_DIR:/var/www/html/wordpress -p 80:80 -p 443:443 --name=$NAME $TAG
else
	echo -e "\n\n\e[91mStop and delete the container $NAME to start again"
	echo -e "\e[39mTo start a new containter run the command:\n"
	echo -e "docker run -it -d -v $PWD/wordpress:/var/www/html/wordpress -p 80:80 -p 443:443 --name=$NAME $TAG";
fi
