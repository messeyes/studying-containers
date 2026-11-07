# Dockerfile

o Dockerfile é um arquivo que contém instruções utilizadas para construir uma imagem Docker.

no meu projeto, estou utilizando Node.js 22 com Alpine e multi-stage build para separar a etapa de construção da aplicação da etapa de execução.

## meu Dockerfile atual

```dockerfile
FROM node:22-alpine AS builder

WORKDIR /usr/src/app

COPY package*.json ./

RUN npm ci

COPY . .

RUN npm run build

FROM node:22-alpine AS production

WORKDIR /usr/src/app

ENV NODE_ENV=production

COPY package*.json ./

RUN npm ci --omit=dev && npm cache clean --force

COPY --from=builder /usr/src/app/dist ./dist

EXPOSE 3000

CMD ["npm", "run", "start"]
```

## entendendo cada instrução

### FROM

```dockerfile
FROM node:22-alpine AS builder
```

define a imagem que será utilizada como base.

estou utilizando o Node.js 22 com Alpine, uma distribuição Linux mais enxuta, que ajuda a reduzir o tamanho da imagem.

o `AS builder` dá um nome para essa etapa. assim, consigo identificá-la e utilizar seus arquivos em outras etapas do Dockerfile.

### WORKDIR

```dockerfile
WORKDIR /usr/src/app
```

define o diretório de trabalho dentro do container.

é como executar um `cd /usr/src/app` no terminal.

se o diretório não existir, o Docker cria automaticamente.

### COPY

```dockerfile
COPY package*.json ./
```

copia os arquivos `package.json` e `package-lock.json` para o diretório de trabalho.

esses arquivos contêm as informações e as versões das dependências do projeto.

copio eles primeiro para aproveitar o cache do Docker. assim, se eu alterar somente o código-fonte, não preciso necessariamente instalar todas as dependências novamente.

### RUN

```dockerfile
RUN npm ci
```

instala as dependências do projeto utilizando o `package-lock.json`.

utilizo `npm ci` porque ele instala as versões registradas no arquivo de lock, sendo indicado para ambientes em que preciso manter uma instalação reproduzível.

nessa primeira etapa, são instaladas tanto as dependências de produção quanto as de desenvolvimento.

### COPY

```dockerfile
COPY . .
```

copia o restante dos arquivos do projeto para dentro do container.

como os arquivos de dependências já foram copiados anteriormente, agora posso copiar o código-fonte e os arquivos de configuração.

essa cópia também respeita as regras do `.dockerignore`.

### RUN

```dockerfile
RUN npm run build
```

executa o script `build` definido no `package.json`.

no meu projeto NestJS, esse comando utiliza o Nest CLI para compilar o código TypeScript.

depois da compilação, os arquivos JavaScript são gerados na pasta `dist`.

## segunda etapa: production

```dockerfile
FROM node:22-alpine AS production
```

aqui começa uma nova etapa da construção da imagem.

utilizo novamente a imagem Node.js 22 Alpine, mas agora com o objetivo de preparar somente o ambiente necessário para executar a aplicação.

uma característica importante do multi-stage build é que essa etapa começa com uma imagem limpa. ela não recebe automaticamente os arquivos e as dependências da etapa `builder`.

### ENV

```dockerfile
ENV NODE_ENV=production
```

define a variável de ambiente `NODE_ENV` com o valor `production`.

isso indica que a aplicação está sendo executada em ambiente de produção.

### WORKDIR e COPY

```dockerfile
WORKDIR /usr/src/app

COPY package*.json ./
```

defino novamente o diretório de trabalho e copio os arquivos de dependências.

preciso fazer isso porque estou em uma nova etapa, que possui seu próprio sistema de arquivos.

### RUN npm ci --omit=dev

```dockerfile
RUN npm ci --omit=dev && npm cache clean --force
```

esse comando possui duas operações.

**1. instalar somente as dependências de produção**

```bash
npm ci --omit=dev
```

o `--omit=dev` faz com que o npm não instale os pacotes declarados em `devDependencies`.

assim, evito levar ferramentas utilizadas apenas durante o desenvolvimento para a imagem final.

**2. limpar o cache do npm**

```bash
npm cache clean --force
```

remove o cache armazenado pelo npm dentro da imagem.

isso ajuda a evitar que arquivos temporários de instalação ocupem espaço desnecessário.

o `&&` indica que o segundo comando só será executado se o primeiro terminar com sucesso.

### COPY --from

```dockerfile
COPY --from=builder /usr/src/app/dist ./dist
```

copia a pasta `dist` da etapa chamada `builder` para a etapa atual, chamada `production`.

o `--from=builder` indica de qual etapa quero copiar os arquivos.

não preciso copiar novamente todo o código-fonte, pois a aplicação já foi compilada na primeira etapa.

### EXPOSE

```dockerfile
EXPOSE 3000
```

documenta que a aplicação utiliza a porta 3000 dentro do container.

essa instrução não publica a porta automaticamente.

para acessar a aplicação pela minha máquina, preciso utilizar o mapeamento de portas:

```bash
docker run -p 3000:3000 minha-imagem
```

o primeiro número representa a porta da minha máquina e o segundo representa a porta dentro do container.

### CMD

```dockerfile
CMD ["npm", "run", "start"]
```

define o comando padrão que será executado quando o container iniciar.

nesse caso, executa o script `start` definido no `package.json`.

## entendendo o multi-stage build

o multi-stage build permite dividir a construção da imagem em diferentes etapas.

no meu projeto, utilizo duas:

**builder**

- instala todas as dependências.
- recebe o código-fonte.
- compila a aplicação.
- gera a pasta `dist`.

**production**

- começa com uma nova imagem.
- instala somente as dependências de produção.
- recebe a pasta `dist` da etapa `builder`.
- prepara o ambiente para executar a aplicação.

o fluxo fica assim:

```text
builder
  |
  |-- instala todas as dependências
  |-- copia o código-fonte
  |-- executa o build
  |-- gera a pasta dist
  |
  v
production
  |
  |-- começa com uma imagem limpa
  |-- instala somente dependências de produção
  |-- copia a pasta dist do builder
  |-- inicia a aplicação
```

a principal vantagem é que não preciso incluir todas as ferramentas de desenvolvimento na imagem final.

## diferença entre RUN e CMD

essas duas instruções são utilizadas em momentos diferentes.

- `RUN`: executa comandos durante a construção da imagem.
- `CMD`: define o comando padrão executado quando o container inicia.

no meu projeto:

```dockerfile
RUN npm run build

CMD ["npm", "run", "start"]
```

primeiro, a aplicação é compilada durante o build. depois, quando o container inicia, o comando definido em `CMD` é executado.

## resumo das instruções utilizadas

| instrução | função |
|---|---|
| `FROM` | define a imagem base |
| `WORKDIR` | define o diretório de trabalho |
| `COPY` | copia arquivos para a imagem |
| `RUN` | executa comandos durante o build |
| `ENV` | define variáveis de ambiente |
| `EXPOSE` | documenta a porta utilizada |
| `CMD` | define o comando de inicialização |
