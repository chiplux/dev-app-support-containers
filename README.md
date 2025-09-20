# dev-app-support-containers

This repository contains Docker Compose configurations for self-hosting various applications.

## Applications

### Excalidraw

Excalidraw is a virtual collaborative whiteboarding app that you can self-host.

#### Setup

1. Ensure you have Docker and Docker Compose installed
2. Copy the `.env.example` file to `.env` and modify as needed:
   ```bash
   cd excalidraw
   cp .env.example .env
   # Edit .env to customize ports and other settings
   ```
3. Run `make run APP=excalidraw` to start the Excalidraw containers
4. Access Excalidraw at http://localhost:3000
5. Access Excalidraw Room at http://localhost:8080

### Vault Warden

Vault Warden is a Bitwarden compatible server written in Rust.

#### Setup

1. Ensure you have Docker and Docker Compose installed
2. Copy the `.env.example` file to `.env` and modify as needed:
   ```bash
   cd vault-warden
   cp .env.example .env
   # Edit .env to customize ports, enable signups, configure email, etc.
   ```
3. Run `make run APP=vault-warden` to start the Vault Warden container
4. Access Vault Warden at http://localhost:8000

## Management

Use the provided Makefile to manage the applications:

```bash
# For a specific app
make run APP=app_name        # Start containers for a specific app
make stop APP=app_name       # Stop containers for a specific app
make backup APP=app_name     # Backup data for a specific app
make status APP=app_name     # Show container status for a specific app
make logs APP=app_name       # Show container logs for a specific app
make clean APP=app_name      # Stop and remove containers for a specific app

# For all apps
make run-all                 # Start containers for all apps
make stop-all                # Stop containers for all apps
make clean-all               # Stop and remove containers for all apps
```

### Configuration

Each application has its own directory with a docker-compose.yml file that you can modify to:
- Change port mappings
- Configure persistent data volumes
- Adjust environment variables

### Adding New Applications

To add a new application:

1. Create a new directory for the application (e.g., `mkdir app-name`)
2. Create a `docker-compose.yml` file in that directory
3. Add the application name to the `APPS` variable in the Makefile
