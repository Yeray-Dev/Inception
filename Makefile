NAME = Inception
SRC_DIR = srcs
COMPOSE_FILE = srcs/docker-compose.yml

all: up

secrets:
	mkdir -p srcs/requirements/secrets
	cp /home/yblanco-/Documents/requirements/secrets/*.txt srcs/requirements/secrets/

up: secrets
	mkdir -p ~/data/mariadb ~/data/wordpress
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
	sudo rm -rf ~/data/mariadb ~/data/wordpress

.PHONY: all up down re clean fclean secrets
