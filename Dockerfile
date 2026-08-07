# Estágio 1: Build da aplicação Flutter Web
FROM ghcr.io/cirruslabs/flutter:stable AS build-env

# Define o diretório de trabalho
WORKDIR /app

# Copia os arquivos de dependência primeiro para aproveitar o cache do Docker
COPY pubspec.* ./
RUN flutter pub get

# Copia o restante do código da aplicação
COPY . .

# Faz o build da aplicação para web em modo release
RUN flutter build web --release

# Estágio 2: Servir a aplicação utilizando o Nginx
FROM nginx:alpine

# Copia o build gerado no estágio anterior para o diretório padrão do Nginx
COPY --from=build-env /app/build/web /usr/share/nginx/html

# Copia o arquivo de configuração do Nginx (necessário para rotas no Flutter Web)
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Expõe a porta 80 do container
EXPOSE 80

# Inicia o servidor Nginx
CMD ["nginx", "-g", "daemon off;"]
