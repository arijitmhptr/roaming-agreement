#Run all the containers--command
docker-compose -f ./docker/docker-compose.yaml down --volumes
echo "========== All containers are DOWN ================="

# delete stopped containers
docker rm $(docker ps -a -q)
echo "========== All the stopped containers are down ================="

# Delete all docker volumes
docker volume prune -f
echo "========== All the volumes are deleted ================="