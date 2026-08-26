NAME = Inception
SRC_DIR = srcs
COMPOSE_FILE = srcs/docker-compose.yml

all: up

SECRETS_DIR := srcs/requirements/secrets

$(SECRETS_DIR):
	mkdir -p $@
	openssl rand -base64 24 | tr -d '\n' > $@/db_password.txt
	openssl rand -base64 24 | tr -d '\n' > $@/db_root_password.txt
	openssl rand -base64 24 | tr -d '\n' > $@/wp_user_password.txt
	openssl rand -base64 24 | tr -d '\n' > $@/wp_admin_password.txt

# secrets:
# 	mkdir -p srcs/requirements/secrets
# 	cp /home/yblanco-/Documents/requirements/secrets/*.txt srcs/requirements/secrets/

up: $(SECRETS_DIR)
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
	docker volume prune -af
	sudo rm -rf ~/data/mariadb ~/data/wordpress

.PHONY: all up down re clean fclean
