#Estágio 1 - Construir uma imagem docker do React

FROM node:17.5.0-alpine as build-stage

#Criando o diretório de trabalho
RUN mkdir /usr/app

#Copiando os arquivos para o diretório
COPY ./App /usr/app

#Definindo diretório de trabalho
WORKDIR /usr/app

#Instalando todas dependências
RUN npm install

#Adicionando .bin no PATH
ENV PATH /usr/src/app/node_modules/.bin:$PATH

#Criando uma build de produção otimizada
RUN npm run build


#Estágio 2 - Copiando o React App para o NGINX
FROM nginx

#Definindo diretório de trabalho do NGINX
WORKDIR /usr/share/nginx/html

#Removendo todos arquivos padrões do diretório de trabalho
RUN rm -rf ./*

#Copiando a build gerada para o diretório de trabalho do nginx
COPY --from=build-stage /usr/app/build  /usr/share/nginx/html

#Copiando o arquivo de configuração do servidor para a configuração padrão do nginx
COPY ./Nginx/nginx.conf /etc/nginx/conf.d/default.conf

#Expondo a porta 80/TCP
EXPOSE 80

#Iniciando o nginx em modo forground
CMD ["nginx", "-g", "daemon off;"]
