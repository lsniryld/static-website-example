FROM ubuntu:18.04
MAINTAINER lsniryniry (adrianajade.erin@gmail.com)
RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y nginx git
EXPOSE 80
RUN mkdir -p /var/www/html/
RUN rm -rf /var/www/html/*
ADD assets /var/www/html/
ADD error /var/www/html/
ADD images /var/www/html/
ADD *.MD /var/www/html/
ADD index.html /var/www/html/
#RUN git clone https://github.com/diranetafen/static-website-example.git  /var/www/html/
ENTRYPOINT ["/usr/sbin/nginx", "-g", "daemon off;"]
