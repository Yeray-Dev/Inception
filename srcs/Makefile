NAME = Inception

SRC_DIR	= srcs
COMPOSE_FILE	= srcs/docker-compose.yml

all:	up

up:
	docker compose -f $(COMPOSE_FILE) up --build -d

down:
	docker compose -f $(COMPOSE_FILE) down

re:
	$(MAKE) down 
	$(MAKE) up

clean:
	docker compose -f $(COMPOSE_FILE) down --rmi all
	docker network prune -f

fclean:
	$(MAKE) clean
	docker volume prune -f

.PHONY: all up down re clean fclean
