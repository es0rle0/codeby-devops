FROM debian:11

RUN apt-get update \
 && apt-get install -y --no-install-recommends nginx ca-certificates \
 && rm -rf /var/lib/apt/lists/* \
 && mkdir -p /opt/www \
 && rm -f /etc/nginx/sites-enabled/default

COPY index.html /opt/www/index.html
COPY nginx.conf /etc/nginx/sites-available/lesson16.conf
RUN ln -s /etc/nginx/sites-available/lesson16.conf /etc/nginx/sites-enabled/lesson16.conf

COPY entrypoint.sh /entrypoint.sh

EXPOSE 80

ENTRYPOINT ["/entrypoint.sh"]
