#!/bin/bash
NAME=test_01
TAG=test:v0.3
docker stop $NAME && docker rm $NAME
docker rmi $TAG
