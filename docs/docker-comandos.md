# Docker — Anotações de estudo

principais comandos que eu vi durante o curso e que pesquisei para estudar.

## 1. básicos do Docker

```bash
docker --version
```
verifica a versão do Docker instalada.

```bash
docker version
```
mostra a versão do cliente e do servidor Docker.

```bash
docker info
```
mostra informações sobre o ambiente Docker.

```bash
docker run hello-world
```
testa se o Docker está funcionando, baixa e executa uma imagem de teste.

## 2. imagens

imagens são utilizadas para criar containers.

```bash
docker images
```
lista as imagens que tenho na máquina.

```bash
docker pull node:22-slim
```
baixa uma imagem do Docker Hub.

```bash
docker build -t nome-da-imagem .
```
constrói uma imagem utilizando o Dockerfile do diretório atual.

- `-t`: define o nome da imagem.
- `.`: indica o diretório atual como contexto do build.

```bash
docker build --no-cache -t nome-da-imagem .
```
constrói a imagem sem utilizar o cache.

```bash
docker image inspect nome-da-imagem
```
mostra informações da imagem.

```bash
docker rmi nome-da-imagem
```
remove uma imagem.

## 3. containers

um container é uma instância de uma imagem.

```bash
docker ps
```
lista os containers em execução.

```bash
docker ps -a
```
lista todos os containers, inclusive os parados.

```bash
docker run nome-da-imagem
```
cria e inicia um container.

```bash
docker run -d nome-da-imagem
```
executa o container em segundo plano.

```bash
docker run --name meu-container nome-da-imagem
```
define um nome para o container.

```bash
docker run -p 3000:3000 nome-da-imagem
```
mapeia a porta 3000 da minha máquina para a porta 3000 do container.

```bash
docker run -d --name minha-api -p 3000:3000 nome-da-imagem
```
cria e inicia um container em segundo plano, com nome e porta definidos.

```bash
docker start meu-container
```
inicia um container que já existe.

```bash
docker stop meu-container
```
para um container em execução.

```bash
docker restart meu-container
```
reinicia um container.

```bash
docker rm meu-container
```
remove um container parado.

```bash
docker rm -f meu-container
```
força a remoção de um container, mesmo que esteja rodando.

## 4. logs e acesso ao container

```bash
docker logs meu-container
```
mostra os logs do container.

```bash
docker logs -f meu-container
```
acompanha os logs em tempo real.

```bash
docker logs --tail 100 meu-container
```
mostra somente as últimas 100 linhas.

```bash
docker exec -it meu-container sh
```
abre um terminal dentro do container.

- `exec`: executa um comando em um container existente.
- `-i`: mantém a entrada interativa.
- `-t`: disponibiliza um terminal.
- `sh`: abre o shell.

```bash
docker exec meu-container ls
```
executa o comando `ls` dentro do container.

```bash
docker inspect meu-container
```
mostra informações detalhadas do container.

```bash
docker stats
```
mostra o consumo de CPU, memória e rede dos containers.

## 5. volumes

volumes servem para persistir dados mesmo quando um container é removido.

```bash
docker volume ls
```
lista os volumes.

```bash
docker volume create meu-volume
```
cria um volume.

```bash
docker volume inspect meu-volume
```
mostra informações do volume.

```bash
docker volume rm meu-volume
```
remove um volume que não está sendo utilizado.

exemplo utilizando um volume:

```bash
docker run -d \
  --name meu-banco \
  -v meu-volume:/var/lib/postgresql/data \
  postgres:17
```

O `-v` conecta o volume ao diretório de dados do PostgreSQL.

## 6. redes

redes permitem que containers se comuniquem.

```bash
docker network ls
```
lista as redes disponíveis.

```bash
docker network create minha-rede
```
cria uma rede.

```bash
docker network inspect minha-rede
```
mostra informações da rede.

```bash
docker network connect minha-rede meu-container
```
conecta um container a uma rede existente.

```bash
docker network rm minha-rede
```
remove uma rede que não está sendo utilizada.

## 7. variáveis de ambiente

servem para configurar a aplicação sem precisar alterar o código.

```bash
docker run -e NODE_ENV=production nome-da-imagem
```
define uma variável de ambiente.

```bash
docker run --env-file .env nome-da-imagem
```
carrega as variáveis de um arquivo `.env`.

importante: não enviar arquivos `.env` com senhas e credenciais para o GitHub.

## 8. docker Compose

utilizo o Compose para executar aplicações que precisam de vários serviços, como uma API e um banco de dados.

```bash
docker compose up
```
cria e inicia os serviços.

```bash
docker compose up -d
```
inicia os serviços em segundo plano.

```bash
docker compose up --build
```
constrói as imagens e inicia os serviços.

```bash
docker compose ps
```
lista os serviços em execução.

```bash
docker compose logs
```
mostra os logs dos serviços.

```bash
docker compose logs -f
```
acompanha os logs em tempo real.

```bash
docker compose exec api sh
```
abre um terminal no serviço chamado `api`.

```bash
docker compose stop
```
para os serviços sem remover os containers.

```bash
docker compose down
```
para e remove os containers e redes criados pelo Compose.

```bash
docker compose down -v
```
também remove os volumes. Cuidado: posso perder os dados armazenados neles.

## 9. limpeza

```bash
docker system df
```
mostra quanto espaço o Docker está utilizando.

```bash
docker container prune
```
remove containers parados.

```bash
docker image prune
```
remove imagens dangling (sem referência).

```bash
docker volume prune
```
remove volumes não utilizados.

```bash
docker system prune
```
remove recursos não utilizados, como containers parados, redes e cache de build.

```bash
docker system prune -a
```
também remove imagens que não estão sendo utilizadas por containers existentes.

tomar cuidado com os comandos de limpeza, principalmente quando envolvem volumes, pois posso perder dados.

## 10. meu fluxo básico de trabalho

quando quero executar uma aplicação utilizando Docker:

construir a imagem:

```bash
docker build -t minha-aplicacao .
```

criar e iniciar o container:

```bash
docker run -d --name minha-aplicacao -p 3000:3000 minha-aplicacao
```

verificar se está rodando:

```bash
docker ps
```

verificar os logs:

```bash
docker logs -f minha-aplicacao
```

parar o container:

```bash
docker stop minha-aplicacao
```

remover o container, se não precisar mais dele:

```bash
docker rm minha-aplicacao
```

---

## refs

- [Documentação oficial do Docker](https://docs.docker.com/)
- [Docker CLI](https://docs.docker.com/reference/cli/docker/)
- [Docker Compose](https://docs.docker.com/compose/)
