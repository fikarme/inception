all : data up

data:
	mkdir -p /home/hozkaya/data
	mkdir -p /home/hozkaya/data/wordpress
	mkdir -p /home/hozkaya/data/mariadb

up: 
	docker-compose -f ./srcs/docker-compose.yml up -d

down: 
	docker-compose -f ./srcs/docker-compose.yml down

start: 
	docker-compose -f ./srcs/docker-compose.yml start

stop: 
	docker-compose -f ./srcs/docker-compose.yml stop

clean: down
	docker system prune -a

fclean: clean
	sudo rm -rf /home/hozkaya/data/wordpress
	sudo rm -rf /home/hozkaya/data/mariadb
	sudo rm -rf /home/hozkaya/data

re : fclean all

.PHONY: all data up down stop start clean fclean re