FROM httpd:2.4.57-bullseye
RUN apt-get update && apt-get install -y --no-install-recommends ca-certificates openssl nano apache2-utils
COPY ./conf/apache/custom_apache_startup.sh /custom_apache_startup.sh
RUN chmod u+x /custom_apache_startup.sh
ENTRYPOINT ["/custom_apache_startup.sh"]