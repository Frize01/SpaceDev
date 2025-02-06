.PHONY: build up down down-v help

build:
	UID=$(id -u) GID=$(id -g) docker compose build

up:
	UID=$(id -u) GID=$(id -g) docker compose up -d

down:
	UID=$(id -u) GID=$(id -g) docker compose down

down-v:
	UID=$(id -u) GID=$(id -g) docker compose down -v

mail-hog:
	docker run -p 8025:8025 -p 1025:1025 mailhog/mailhog

help:
	@echo "Commands:"
	@echo "  build   - Build the Docker images"
	@echo "  up      - Start the Docker containers"
	@echo "  down    - Stop the Docker containers"
	@echo "  down-v  - Stop the Docker containers and remove volumes"
	@echo "  help    - Display this help message"