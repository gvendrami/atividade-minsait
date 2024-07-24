#!/bin/bash
set -e

apt-get update # atualiza a lista de pacotes.
apt-get install -y apt-transport-https ca-certificates curl software-properties-common # instala alguns recursos necessários,

# aqui é adicionado o repositório do docker no sistema.
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
add-apt-repository -y "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
apt-get update -y

apt-get install -y docker-ce # instalação do docker.

# é a inicialização do docker e sua configuração para iniciar automaticamente com o sistema.
systemctl start docker
systemctl enable docker

curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose # baixa o docker compose e instala ele.
chmod +x /usr/local/bin/docker-compose # o docker compose se torna executável.

# aqui é criado um diretório para o teste do wordpress e adiciona o arquivo docker-compose.yml
mkdir -p /home/ubuntu/wordpress
cat <<EOF > /home/ubuntu/wordpress/docker-compose.yml
version: '3.8'

services:
  wordpress:
    # usa o dockerfile no diretório atual para construir a imagem do wordpress.
    build: . 
    container_name: wordpress
    ports: # mapeia a porta 80 para a porte 8080 do host. mudei mais por familiaridade em alguns casos também em alguns testes antigos.
      - "8080:80"
    # são as definições de ambiente para conectar ao banco de dados    
    environment:
      WORDPRESS_DB_HOST: db:3306
      WORDPRESS_DB_NAME: wordpress
      WORDPRESS_DB_USER: root
      WORDPRESS_DB_PASSWORD: GAud4mZby8F3SD6P  
    volumes: # mapeia um volume para a armezenação dos dados do wordpress.
      - wordpress_data:/var/www/html
    depends_on: # é a garantia de que o conteiner do wordpress só inicie depois do banco de dados estiver disponível. importante para nao dar erro no código.
      - db

  db:
    # utiliza a imagem padrao do mysql versao 5.7.
    image: mysql:5.7
    container_name: db
    # definição de variáveis de ambiente para a configuração do mysql.
    environment:
      MYSQL_ROOT_PASSWORD: GAud4mZby8F3SD6P
      MYSQL_DATABASE: wordpress
    # mapeia um volume para a armazenação dos dados do mysql.
    volumes:
      - db_data:/var/lib/mysql

# definição dos volumes para a estabilidade dos dados.
volumes:
  wordpress_data:
  db_data:
EOF

# adiciona um dockerfile, mas nesse caso , é basicamente o padrão do wordpress.
cat <<EOF > /home/ubuntu/wordpress/Dockerfile
# utilizei a imagem padrao mesmo do wordpress para o teste.
FROM wordpress:latest

# aqui é o local ideal para instalar algum pacote adicional ou arquivos personalizados. é que adiciona ambos.

# são as definições da variável de ambiente para a configuração do wordpress
ENV WORDPRESS_DB_HOST=db:3306
ENV WORDPRESS_DB_NAME=wordpress
ENV WORDPRESS_DB_USER=root
ENV WORDPRESS_DB_PASSWORD=GAud4mZby8F3SD6P

# o expose expõe a porta para o recebimento de requisições no wordpress.
EXPOSE 80

# inicia o servidor do wordpress.
CMD ["apache2-foreground"]
EOF

# Iniciar os containers
cd /home/ubuntu/wordpress
docker-compose up -d