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
