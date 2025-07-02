all : up

up :
	mkdir -p /home/akdemir/data
	mkdir -p /home/akdemir/data/wordpress
	mkdir -p /home/akdemir/data/mariadb
	@docker-compose -f ./docker-compose.yml up -d
#	-d	runs containers in detached mode (in the background)
#	-f	specifies the compose file location

down :
	@docker-compose -f ./docker-compose.yml down

start :
	@docker-compose -f ./docker-compose.yml start

stop :
	@docker-compose -f ./docker-compose.yml stop

clean : down
	@docker system prune -a
#	-a	flag removes all unused images, not just dangling ones

fclean :
	sudo rm -rf /home/akdemir/data/wordpress
	sudo rm -rf /home/akdemir/data/mariadb
	sudo rm -rf /home/akdemir/data
	docker stop $$(docker ps -qa) 2>/dev/null || true
#	2>/dev/null	suppresses error messages if no containers are running
#	|| true		if there are no containers to stop make file continue without error

	docker rm $$(docker ps -qa) 2>/dev/null || true
#	-q	only lists container IDs (12 char hash)
#	-a	lists all containers (including build cache layers)

	docker rm $$(docker ps -qa) 2>/dev/null || true
	docker rmi -f $$(docker images -qa) 2>/dev/null || true
#	-f	force flag to remove images with dependencies
#	without -f, Docker will refuse to remove images that have dependent containers
#	(even stopped ones) or are referenced by other images

	docker volume rm $$(docker volume ls -q) 2>/dev/null || true
	docker network rm $$(docker network ls -q) 2>/dev/null || true

re : fclean all

.PHONY: all up down stop start restart status clean fclean re
