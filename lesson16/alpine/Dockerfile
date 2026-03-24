FROM alpine:latest

RUN apk add --no-cache nginx \
 && mkdir -p /opt/www /run/nginx \
 && rm -f /etc/nginx/http.d/default.conf

COPY index.html /opt/www/index.html
COPY nginx.conf /etc/nginx/http.d/default.conf

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
