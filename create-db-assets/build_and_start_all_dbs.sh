#!/bin/bash

set -eu


function echo_paramters(){
	description=$1
	docker_image_name=$2
	docker_container_name=$3
	db_port_number=$4
	db_password=$5
	db_name=$6
	db_sql_script_file=$7   
		echo "description = $description"
		echo "docker_image_name = $docker_image_name"
		echo "docker_container_name = $docker_container_name"
		echo "db_port_number = $db_port_number"
		echo "db_password = $db_password"
		echo "db_name = $db_name"
		echo "db_sql_script_file = $db_sql_script_file"

}


function start_db(){
	description=$1
	docker_image_name=$2
	docker_container_name=$3
	db_port_number=$4
	db_password=$5
	db_name=$6
	db_sql_script_file=$7    
    
	image_exists=false
	container_is_running=false
	container_exists=false

	#Check if image exists
		docker image inspect $docker_image_name>/dev/null 2>&1 && image_exists=true || image_exists=false
		echo "Image $docker_image_name exists = $image_exists"
		if [ "$image_exists" = false ] 
		then
			echo "Image $docker_image_name does not exist so it will be created"
			sleep 1
			#Create a new image with build args passed in as arguments     
				docker build --no-cache --pull -t $docker_image_name --build-arg DB_PASSWORD="$db_password" --build-arg DB_NAME="$db_name" --build-arg SQL_SCRIPT_FILE="$db_sql_script_file" .
		else
			echo "Image $docker_image_name already exists, so wont be created"
		fi
		
		#Check if container exists and  is running
			(docker ps -a --format {{.Names}} | grep $docker_container_name -w) && container_exists=true || container_exists=false
			echo "Container $docker_container_name is-existing = $container_exists"
			if [ "$container_exists" = false ]
			then
				#Create a new container and start it up
					echo "Image $docker_container_name does not exist and is not running so it will be created and started"
					docker run --name $docker_container_name -d -p $db_port_number:3306 $docker_image_name
					echo "$docker_container_name was started and the database is listening on  PORT $db_port_number"		 
			else
				echo "Container $docker_container_name already exists so wont be created."
				#Check if container is running
					(docker ps --format {{.Names}} | grep $docker_container_name -w) && container_is_running=true || container_is_running=false
					echo "Container $docker_container_name is-running = $container_is_running"
					if [ "$container_is_running" = true ] 
					then
						echo "Container $docker_container_name is already running, so wont be disturbed"
						sleep 1
					else
						echo "Container $docker_container_name exist but is not running, so it will be started"
						docker start $docker_container_name
				fi 	
			fi
}


	# Initialise variables
		config_file_name=create-db.json
		description=""
		docker_image_name=""
		docker_container_name=""
		db_port_number=3306
		db_password=""
		db_name=""
		db_sql_script_file=""

	# read all sub-directories into the directories array
		directories=(*/)

	# loop through and start the dbs
	for directory in "${directories[@]}"; do
		description="$(cat ./$directory$config_file_name | jq -r '.description')"
		docker_image_name="$(cat ./$directory$config_file_name | jq -r '.docker_image_name')"
		docker_container_name="$(cat ./$directory$config_file_name | jq -r '.docker_container_name')"
		db_port_number="$(cat ./$directory$config_file_name | jq -r '.db_port_number')"
		db_password="$(cat ./$directory$config_file_name | jq -r '.db_password')"
		db_name="$(cat ./$directory$config_file_name | jq -r '.db_name')"
		db_sql_script_file="$(cat ./$directory$config_file_name | jq -r '.db_sql_script_file')"
		start_db "$description" $docker_image_name $docker_container_name $db_port_number $db_password $db_name ./$directory$db_sql_script_file
	done