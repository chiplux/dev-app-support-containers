
# Makefile for managing Docker containers

# Variables
APPS := excalidraw vault-warden
EXCALIDRAW_DIR := excalidraw
VAULTWARDEN_DIR := vault-warden
DOCKER_COMPOSE := docker compose

# Default target
.PHONY: help
help:
	@echo "Docker Container Management"
	@echo ""
	@echo "Usage:"
	@echo "  make run APP=app_name     - Start containers for a specific app"
	@echo "  make run-all              - Start containers for all apps"
	@echo "  make stop APP=app_name    - Stop containers for a specific app"
	@echo "  make stop-all             - Stop containers for all apps"
	@echo "  make backup APP=app_name  - Backup data for a specific app"
	@echo "  make status APP=app_name  - Show container status for a specific app"
	@echo "  make logs APP=app_name    - Show container logs for a specific app"
	@echo "  make clean APP=app_name   - Stop and remove containers for a specific app"
	@echo "  make clean-all            - Stop and remove containers for all apps"
	@echo ""
	@echo "Available apps: $(APPS)"
	@echo ""
	@echo "Examples:"
	@echo "  make run APP=excalidraw"
	@echo "  make backup APP=vault-warden"

# Run containers for a specific app
.PHONY: run
run:
	@if [ -z "$(APP)" ]; then \
		echo "Error: APP variable not set. Usage: make run APP=app_name"; \
		exit 1; \
	fi
	@if [ ! -d "$(APP)" ]; then \
		echo "Error: Directory $(APP) does not exist"; \
		exit 1; \
	fi
	@if [ ! -f "$(APP)/docker-compose.yml" ]; then \
		echo "Error: $(APP)/docker-compose.yml not found"; \
		exit 1; \
	fi
	@echo "Starting $(APP) containers..."
	$(DOCKER_COMPOSE) -f $(APP)/docker-compose.yml -p $(APP) up -d
	@echo "$(APP) containers started."

# Run containers for all apps
.PHONY: run-all
run-all:
	@echo "Starting excalidraw containers..."
	@if [ -d "excalidraw" ] && [ -f "excalidraw/docker-compose.yml" ]; then \
		$(DOCKER_COMPOSE) -f excalidraw/docker-compose.yml -p excalidraw up -d; \
		echo "excalidraw containers started."; \
	else \
		echo "Skipping excalidraw: docker-compose.yml not found."; \
	fi
	@echo "Starting vault-warden containers..."
	@if [ -d "vault-warden" ] && [ -f "vault-warden/docker-compose.yml" ]; then \
		$(DOCKER_COMPOSE) -f vault-warden/docker-compose.yml -p vault-warden up -d; \
		echo "vault-warden containers started."; \
	else \
		echo "Skipping vault-warden: docker-compose.yml not found."; \
	fi

# Stop containers for a specific app
.PHONY: stop
stop:
	@if [ -z "$(APP)" ]; then \
		echo "Error: APP variable not set. Usage: make stop APP=app_name"; \
		exit 1; \
	fi
	@if [ ! -d "$(APP)" ]; then \
		echo "Error: Directory $(APP) does not exist"; \
		exit 1; \
	fi
	@if [ ! -f "$(APP)/docker-compose.yml" ]; then \
		echo "Error: $(APP)/docker-compose.yml not found"; \
		exit 1; \
	fi
	@echo "Stopping $(APP) containers..."
	$(DOCKER_COMPOSE) -f $(APP)/docker-compose.yml -p $(APP) stop
	@echo "$(APP) containers stopped."

# Stop containers for all apps
.PHONY: stop-all
stop-all:
	@echo "Stopping excalidraw containers..."
	@if [ -d "excalidraw" ] && [ -f "excalidraw/docker-compose.yml" ]; then \
		$(DOCKER_COMPOSE) -f excalidraw/docker-compose.yml -p excalidraw stop; \
		echo "excalidraw containers stopped."; \
	else \
		echo "Skipping excalidraw: docker-compose.yml not found."; \
	fi
	@echo "Stopping vault-warden containers..."
	@if [ -d "vault-warden" ] && [ -f "vault-warden/docker-compose.yml" ]; then \
		$(DOCKER_COMPOSE) -f vault-warden/docker-compose.yml -p vault-warden stop; \
		echo "vault-warden containers stopped."; \
	else \
		echo "Skipping vault-warden: docker-compose.yml not found."; \
	fi

# Backup data for a specific app
.PHONY: backup
backup:
	@if [ -z "$(APP)" ]; then \
		echo "Error: APP variable not set. Usage: make backup APP=app_name"; \
		exit 1; \
	fi
	@if [ ! -d "$(APP)" ]; then \
		echo "Error: Directory $(APP) does not exist"; \
		exit 1; \
	fi
	@echo "Creating backup of $(APP) data..."
	@mkdir -p backups/$(APP)
	@timestamp=$(date +%Y%m%d_%H%M%S); \
	docker run --rm -v $(APP)_data:/data -v ${PWD}/backups/$(APP):/backup alpine tar czf /backup/$(APP)_data_backup_${timestamp}.tar.gz -C / data 2>/dev/null || \
	echo "No data volume found or no data to backup for $(APP). If you want to backup data, make sure to configure a volume in $(APP)/docker-compose.yml"
	@echo "Backup for $(APP) completed (if applicable). Check the backups/$(APP) directory."

# Show container status for a specific app
.PHONY: status
status:
	@if [ -z "$(APP)" ]; then \
		echo "Error: APP variable not set. Usage: make status APP=app_name"; \
		exit 1; \
	fi
	@if [ ! -d "$(APP)" ]; then \
		echo "Error: Directory $(APP) does not exist"; \
		exit 1; \
	fi
	@if [ ! -f "$(APP)/docker-compose.yml" ]; then \
		echo "Error: $(APP)/docker-compose.yml not found"; \
		exit 1; \
	fi
	@echo "$(APP) container status:"
	$(DOCKER_COMPOSE) -f $(APP)/docker-compose.yml -p $(APP) ps

# Show container logs for a specific app
.PHONY: logs
logs:
	@if [ -z "$(APP)" ]; then \
		echo "Error: APP variable not set. Usage: make logs APP=app_name"; \
		exit 1; \
	fi
	@if [ ! -d "$(APP)" ]; then \
		echo "Error: Directory $(APP) does not exist"; \
		exit 1; \
	fi
	@if [ ! -f "$(APP)/docker-compose.yml" ]; then \
		echo "Error: $(APP)/docker-compose.yml not found"; \
		exit 1; \
	fi
	@echo "$(APP) container logs:"
	$(DOCKER_COMPOSE) -f $(APP)/docker-compose.yml -p $(APP) logs -f

# Clean (stop and remove containers) for a specific app
.PHONY: clean
clean:
	@if [ -z "$(APP)" ]; then \
		echo "Error: APP variable not set. Usage: make clean APP=app_name"; \
		exit 1; \
	fi
	@if [ ! -d "$(APP)" ]; then \
		echo "Error: Directory $(APP) does not exist"; \
		exit 1; \
	fi
	@if [ ! -f "$(APP)/docker-compose.yml" ]; then \
		echo "Error: $(APP)/docker-compose.yml not found"; \
		exit 1; \
	fi
	@echo "Stopping and removing $(APP) containers..."
	$(DOCKER_COMPOSE) -f $(APP)/docker-compose.yml -p $(APP) down
	@echo "$(APP) containers removed."

# Clean (stop and remove containers) for all apps
.PHONY: clean-all
clean-all:
	@echo "Stopping and removing excalidraw containers..."
	@if [ -d "excalidraw" ] && [ -f "excalidraw/docker-compose.yml" ]; then \
		$(DOCKER_COMPOSE) -f excalidraw/docker-compose.yml -p excalidraw down; \
		echo "excalidraw containers removed."; \
	else \
		echo "Skipping excalidraw: docker-compose.yml not found."; \
	fi
	@echo "Stopping and removing vault-warden containers..."
	@if [ -d "vault-warden" ] && [ -f "vault-warden/docker-compose.yml" ]; then \
		$(DOCKER_COMPOSE) -f vault-warden/docker-compose.yml -p vault-warden down; \
		echo "vault-warden containers removed."; \
	else \
		echo "Skipping vault-warden: docker-compose.yml not found."; \
	fi