FROM debian:buster
RUN apt update && apt install nginx ed -y && \
apt install php7.3-fpm -y && \
apt install php7.3-mysqli -y && \
apt install libnss3-tools wget -y && \
apt install mariadb-server mariadb-client -y; \
mkdir -p /run/php && \
mkdir -p /var/www/html/wordpress; \
chown -R www-data:www-data /var/www/html/wordpress
ADD ./srcs/mariaDB/create_db.sql /home/sql/create_db.sql
ADD ./srcs/mariaDB/wordpress.sql /home/sql/wordpress.sql
RUN service mysql start && \
mysql -u root < /home/sql/create_db.sql; \
mysql -u root wordpress < /home/sql/wordpress.sql;
ADD ./srcs/nginx_conf /etc/nginx/sites-enabled/default
ADD ./srcs/wordpress /var/www/html/wordpress
RUN cd /tmp && wget https://files.phpmyadmin.net/phpMyAdmin/4.9.4/phpMyAdmin-4.9.4-english.tar.gz; \
tar xvf phpMyAdmin-4.9.4-english.tar.gz; \
mv phpMyAdmin-*/ /usr/share/phpmyadmin; \
ln -s /usr/share/phpmyadmin /var/www/html/wordpress/phpmyadmin; \
cd /usr/share/phpmyadmin;
RUN cd && wget -O mkcert https://github.com/FiloSottile/mkcert/releases/download/v1.3.0/mkcert-v1.3.0-linux-amd64; \
chmod +x  mkcert && mv mkcert /usr/local/bin; \
mkcert -install; \
mkcert localhost; \
echo "ssl_certificate /root/.local/share/mkcert/rootCA.pem;" > /etc/nginx/snippets/self-signed.conf; \
echo "ssl_certificate_key /root/.local/share/mkcert/rootCA-key.pem;" >> /etc/nginx/snippets/self-signed.conf;
EXPOSE 80
EXPOSE 443
CMD service nginx start && \
	service mysql start && \
	/etc/init.d/php7.3-fpm start && \
	sleep infinity
WORKDIR /var/www/html/wordpress
