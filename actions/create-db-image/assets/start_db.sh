#!/bin/bash

set -eu

image_name="mp30028/testdb:latest"
container_name="testdb"
image_exists=false
container_is_running=false
container_exists=false

#Check if container is running
(docker ps --format {{.Names}} | grep $container_name -w) && container_is_running=true || container_is_running=false
echo "Container $container_name is running = $container_is_running"
if [ "$container_is_running" = true ] 
then
	echo "Container $container_name will be stopped"
	sleep 1
	docker stop $container_name
fi 	

#Check if container exists
(docker ps -a --format {{.Names}} | grep $container_name -w) && container_exists=true || container_exists=false
echo "Container $container_name exists = $container_exists"
if [ "$container_exists" = true ] 
then
	echo "Container $container_name will be removed"
	sleep 1
	docker rm $container_name
fi 	

#Check if image exists
docker image inspect $image_name>/dev/null 2>&1 && image_exists=true || image_exists=false
echo "Image $image_name exists = $image_exists"
if [ "$image_exists" = true ] 
then
	echo "Image $image_name will be removed"
	sleep 1
	docker rmi $image_name 
fi

#Create a new image
echo "Image $image_name will be created"
docker build --no-cache --pull -t $image_name ./
#docker run --rm --name $container_name -d -p 3306:3306 $image_name

#Create a new container and start it up 
docker run --name $container_name -it -d -p 3307:3306 $image_name /bin/bash

echo "NOTE THE DATABASE PORT IS 3307"