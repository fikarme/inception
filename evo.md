# Preliminary tests
*	For example, the use of a local .env file to store info is allowed, and/or also the use of Docker secrets. If any credentials or API keys are available in the Git repository and outside of secrets files created during the evaluation, the evaluation stops and the mark is 0.
*	The defense can only occur if the evaluated student or group is present. This way, everyone learns by sharing knowledge with one another.
*	If no work has been submitted (or wrong files, wrong directory, or wrong filenames), the grade is 0, and the evaluation process ends.
*	For this project, you must clone their Git repository on their workstation.

# General instructions
*	Throughout the evaluation process, if you do not know how to check a requirement, or verify something, the evaluated student must assist you.
*	Ensure that all files required to configure the application are located within a 'srcs' folder. The 'srcs' folder must be located at the root of the repository.
*	Ensure that a Makefile is located at the root of the repository.
*	Before beginning the evaluation, execute this command in the terminal: "docker stop $(docker ps -qa); docker rm $(docker ps -qa); docker rmi -f $(docker images -qa); docker volume rm $(docker volume ls -q); docker network rm $(docker network ls -q) 2>/dev/null"
*	Read the docker-compose.yml file. There must not be 'network: host' or 'links:' in it. Otherwise, the evaluation ends immediately.
*	Read the docker-compose.yml file. It must contain 'network(s)'. Otherwise, the evaluation ends immediately.
*	Examine the Makefile and all the scripts in which Docker is used. None of them must contain '--link'. Otherwise, the evaluation ends immediately.
*	Examine the Dockerfiles. None of them must contain 'tail -f' or any command running in the background in the ENTRYPOINT section. If there is, the evaluation ends immediately. The same applies if 'bash' or 'sh' are used but not for running a script (e.g., 'nginx & bash' or 'bash').
*	Examine the Dockerfiles. Containers must be built from either the penultimate stable version of Alpine or Debian.
*	If the entrypoint is a script (e.g., ENTRYPOINT \["sh", "my\_entrypoint.sh"\], ENTRYPOINT \["bash", "my\_entrypoint.sh"\]), ensure it runs no program
	 in the background (e.g., 'nginx & bash').
*	Examine all the scripts in the repository. Ensure that none of them runs an infinite loop. The following are examples of prohibited commands: 'sleep infinity', 'tail -f /dev/null', 'tail -f /dev/random'.
*	Run the Makefile.

# Mandatory part
This project involves setting up a small infrastructure composed of different services using docker compose. Ensure that all of the following points are correct.

# Project overview
*	The evaluated person must explain the following to you in simple terms:
	 *	How Docker and docker compose work.
	 *	The difference between a Docker image used with docker compose and without docker compose.
	 *	The benefit of Docker compared to virtual machines (VMs).
	 *	The relevance of the directory structure required for this project (an example is provided in the project's PDF file).

# Simple setup
*	Ensure that NGINX is accessible only through port 443. Once completed, open the page.
*	Ensure that an SSL/TLS certificate is being used.
*	Ensure that the WordPress website is properly installed and configured; you should not see the WordPress installation page. To access it, open https://login.42.fr/ in your browser, where 'login' is the username of the evaluated student. You should not be able to access the site via https://login.42.fr/. If something does not work as expected, the evaluation process ends immediately.

# Docker Basics
*	Begin by checking the Dockerfiles. There must be one Dockerfile for each service. Ensure that the Dockerfiles are not empty. If this is not the case or if a Dockerfile is missing, the evaluation process ends immediately.
*	Ensure that the evaluated student has written their own Dockerfiles and built their own Docker images. It is prohibited to use pre-made ones or services such as DockerHub.
*	Ensure that each container is built from the penultimate stable version of Alpine or Debian. If a Dockerfile does not start with 'FROM alpine:X.X.X', 'FROM debian:XXXXX', or any other local image, the evaluation process ends immediately.
*	Docker images must have the same name as their corresponding service. Otherwise, the evaluation process ends immediately.
*	Ensure that the Makefile sets up all the services via docker compose. This means that the containers must be built using docker compose and that no crashes occur. Otherwise, the evaluation process ends.

# Docker Network
*	Ensure that docker-network is used by checking the docker-compose.yml file. Then, run the 'docker network ls' command to verify that a network is visible.
*	The evaluated student must provide a simple explanation of docker-network. If any of the above points is not correct, the evaluation process ends immediately.

# NGINX with SSL/TLS
*	Ensure that there is a Dockerfile.
*	Using the 'docker compose ps' command, ensure that the container is created (using the flag '-p' is permitted if necessary).
*	Attempt to access the service via HTTP (port 80) and verify that you cannot connect.
*	Open https://login.42.fr/ in your browser, where login is the login of the evaluated student. The displayed page must be the configured WordPress website (you should not see the WordPress installation page).
*	The use of a TLS v1.2/v1.3 certificate is mandatory and must be demonstrated. The SSL/TLS certificate does not have to be recognized. A warning for a self-signed certificate may appear. If any of the above points is not clearly explained and correct, the evaluation process ends immediately.

# WordPress with php-fpm and its volume
*	Ensure that there is a Dockerfile.
*	Ensure that NGINX is not included in the Dockerfile.
*	Using the 'docker compose ps' command, ensure that the container was created (using the flag '-p' is authorized if necessary).
*	Ensure that a volume is present. To do so: Run the command 'docker volume ls' then 'docker volume inspect <volume name>'. Verify that the standard output contains the path '/home/login/data/', where 'login' is the username of the evaluated student.
*	Ensure that you can add a comment using the available WordPress account.
*	Sign in with the administrator account to access the administration dashboard. The administrator username must not include 'admin' or 'Admin' (e.g., admin, administrator, Admin-login, admin-123, etc.).
*	From the administration dashboard, edit a page. Verify on the website that the page is updated. If any of the above points is not correct, the evaluation process ends now.

# MariaDB and its volume
*	Ensure that there is a Dockerfile.
*	Ensure that there is no NGINX in the Dockerfile.
*	Using the 'docker compose ps' command, ensure that the container was created (using the flag '-p' is authorized if necessary).
*	Ensure that there is a Volume. To do so: Run the command 'docker volume ls' then 'docker volume inspect <volume name>'. Verify that the result in the standard output contains the path '/home/login/data/', where login is the login of the evaluated student.
*	The evaluated student must be able to explain how to log in to the database. Ensure that the database is not empty. If any of the above points is not correct, the evaluation process ends now.

# Persistence!
*	This part is straightforward. You must reboot the virtual machine. Once it has restarted, launch docker compose again. Then, verify that everything is functional and that both WordPress and MariaDB are configured. The changes you made previously to the WordPress website should still be present. If any of the above points is not correct, the evaluation process ends now.

# Bonus
Add 1 point per bonus authorized in the subject. Verify and test the proper functioning and implementation of each additional service. For the free choice service, the evaluated student must provide a simple explanation of how it works and why they believe it is useful. Rate it from 0 (failed) through 5 (excellent)
