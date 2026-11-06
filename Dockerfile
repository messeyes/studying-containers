# FROM indica qual imagem base será utilizada para construir a imagem do container. Neste caso, estamos utilizando a imagem oficial do Node.js na versão 22, com a variante "slim", que é uma versão mais leve da imagem.
FROM node:22-slim

# WORKDIR define o diretório de trabalho dentro do container. Todos os comandos subsequentes serão executados a partir deste diretório. Como se eu tivesse usando um cd /usr/src/app no terminal.
WORKDIR /usr/src/app

# COPY package*.json ./: Este comando copia os arquivos package.json e package-lock.json (ou yarn.lock, dependendo do gerenciador de pacotes) do diretório atual do host para o diretório de trabalho dentro do container. Esses arquivos contêm as dependências do projeto.
COPY package*.json ./

# RUN executa comandos no shell do container. Neste caso, estamos instalando as dependências do projeto usando o comando npm ci, que é recomendado para ambientes de produção, pois garante que as dependências sejam instaladas exatamente como especificadas no package-lock.json.
RUN npm ci

# COPY . .: Este comando copia todos os arquivos e diretórios do diretório atual do host para o diretório de trabalho dentro do container. Isso inclui o código-fonte da aplicação, arquivos de configuração, etc. É importante que este comando seja executado após a instalação das dependências para aproveitar o cache do Docker e evitar reinstalar as dependências se apenas o código-fonte mudar.
COPY . .


# RUN npm run build: Este comando executa o script de build definido no package.json. Normalmente, isso envolve a transpilação do código-fonte (por exemplo, de TypeScript para JavaScript) e a preparação dos arquivos para produção.
RUN npm run build

# EXPOSE 3000: Este comando informa ao Docker que o container escutará na porta 3000 em tempo de execução. Isso é útil para mapeamento de portas quando você executa o container, permitindo que você acesse a aplicação através dessa porta (localhost:3000, por exemplo). No entanto, ele não publica a porta por si só; você ainda precisa mapear a porta ao executar o container usando a opção -p.
EXPOSE 3000

# CMD ["npm","run","start"]: Este comando define o comando padrão que será executado quando o container for iniciado. Neste caso, ele inicia a aplicação usando o script start definido no package.json. O uso de CMD permite que você substitua o comando padrão ao iniciar o container, se necessário.
CMD ["npm","run","start"]



