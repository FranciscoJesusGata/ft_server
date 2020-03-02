#!/bin/bash
NAME=wordpress
TAG=ft_server:v1
docker stop $NAME && docker rm $NAME
docker rmi $TAG
