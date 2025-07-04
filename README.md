https://cdimage.debian.org/mirror/cdimage/archive/11.11.0/amd64/iso-cd/

burakdaki mariadb dockerfileda forstman1 gibi script.sh olmaması ve conf dosyalarındaki bind-address satırı

chmod -R 777

sudo nano /etc/hosts

su

sudo apt-get update && apt-get install make docker.io docker-compose

sudo apt update
sudo apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

sudo docker run hello-world
docker compose version

mkdir test-docker && cd test-docker
echo -e "FROM debian:12\nCMD [\"echo\", \"Hello from Debian!\"]" > Dockerfile
docker build -t my-debian-test .
docker run my-debian-test

version: "3.9"
services:
  debian-test:
    image: debian:11
    command: ["echo", "Hello from Docker Compose!"]

docker images          # List locally available images
docker ps              # List running containers (process status)
docker ps -a           # List all containers (including stopped)
docker pull debian:11  # Download the Debian 11 image
docker run -it debian:11 bash  # Start a container interactively
docker stop <container_name_or_id>

----

Image:
- A Docker image is a static file—a snapshot with all the code, libraries, dependencies, and configuration needed to run an application.
- It's like a "blueprint" or "template".
- You can share images via registries (like Docker Hub).

Container:
- A container is a running (or stopped) instance of an image.
- It’s a live, isolated environment that runs your application.
- Containers are created from images, and you can have many containers running from the same image.

----

Network Modes:

bridge
- The default network for containers.
- When you run a container without specifying a network, it connects to bridge.
- Acts like a virtual switch/router, allowing containers on the same bridge network to communicate.
- Containers on bridge can talk to each other (using internal IP addresses) and can access the outside world, but are isolated from containers on other networks.

host
- Removes network isolation between the container and the host.
- The container shares the host’s network stack (same IP, same ports).
- Useful for performance or when you want the container to be "invisible" as a separate network device.
- Only available on Linux.

none
- The container has no network access.
- No network interfaces except for lo (localhost).
- Used for security, or when you want to completely isolate the container from all networking.

----

bridge
- Default for user containers
- Isolated
- Between containers on bridge

host
- High performance, special cases
- Not isolated
- Host and container are same

none
- Maximum isolation, security
- Fully isolated
- No network access

----



----

make up: @docker-compose -f ./docker-compose.yml up -d
- Builds images (if needed).
- Creates containers (if not already created).
- Starts the containers (runs them in the background).
- Runs setup steps like making data directories.
- If containers/images don’t exist, it will create/download them.

make down: docker-compose -f ./docker-compose.yml down
- Stops all containers started by docker-compose.
- Removes those containers, networks, and by default, the default network and any anonymous volumes.
- You lose the containers (but not the data if it’s mounted to persistent volumes).

make stop: docker-compose -f ./docker-compose.yml stop
- Stops the running containers (pauses them).
- Does NOT remove the containers—they still exist and their state is preserved.

make start: docker-compose -f ./docker-compose.yml start
- Starts containers that were stopped (but not removed).
- Uses the existing containers/images; does not rebuild or download again.
