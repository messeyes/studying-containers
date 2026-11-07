# Studying Containers

A hands-on project created to learn Docker and understand how containerization works in practice.

I started this project by generating a NestJS boilerplate using the NestJS CLI. Instead of building an application from scratch, I used this boilerplate as a base to experiment with Docker configurations and learn how to containerize applications.

```bash
npx @nestjs/cli@latest new studying-containers
```

Throughout my research and studies, I explored different Docker concepts, tested configurations and practiced running applications and databases inside containers.

## What I Learned

During this project, I learned how to:

- **Dockerfile:** Creating and configuring Dockerfiles to build application images.
- **Docker Images:** Building and optimizing images to reduce disk space usage and avoid unnecessary dependencies.
- **.dockerignore:** Configuring files and directories that should be excluded from the Docker build context.
- **Docker CLI:** Using terminal commands to create, manage and inspect images and containers.
- **MySQL with Docker:** Setting up and running a MySQL database directly through the terminal.
- **Docker Compose:** Configuring multiple services using a `docker-compose.yml` file.
- **Volumes:** Persisting data even when containers are stopped or removed.
- **Networks:** Creating networks to enable communication between containers.
- **Multiple Containers:** Running and managing multiple containers together, including application and database services.

My notes from this learning process:

[Docker Commands](docs/docker-comands.md)

[Dockerfile Tips](docs/dockerfile-notes.md)

## Course Certificate

[Containers with Docker and Docker Compose — Rocketseat (4 hours)](https://app.rocketseat.com.br/certificates/110dc7c7-be8d-46eb-8f98-e984b85ada54)

Topics covered: Docker fundamentals, Dockerfile configuration, Docker images, .dockerignore, Docker CLI, MySQL with Docker, Docker Compose, Volumes, Networks, and multi-container environments.
