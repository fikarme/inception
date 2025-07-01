all : up

up :
	mkdir -p /home/akdemir/data
	mkdir -p /home/akdemir/data/wordpress
	mkdir -p /home/akdemir/data/mariadb
	@docker-compose -f ./docker-compose.yml up -d

down :
	@docker-compose -f ./docker-compose.yml down

start :
	@docker-compose -f ./docker-compose.yml start

stop :
	@docker-compose -f ./docker-compose.yml stop

clean : down
	@docker system prune -a

fclean :
	sudo rm -rf /home/akdemir/data/wordpress
	sudo rm -rf /home/akdemir/data/mariadb
	sudo rm -rf /home/akdemir/data
	docker stop $$(docker ps -qa) 2>/dev/null || true
	docker rm $$(docker ps -qa) 2>/dev/null || true
	docker rmi -f $$(docker images -qa) 2>/dev/null || true
	docker volume rm $$(docker volume ls -q) 2>/dev/null || true
	docker network rm $$(docker network ls -q) 2>/dev/null || true

re : fclean all

.PHONY: all up down stop start restart status clean fclean re
