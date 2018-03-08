FROM nginx

ADD simple.template /etc/nginx/conf.d/

EXPOSE 80

CMD envsubst < /etc/nginx/conf.d/simple.template > /etc/nginx/conf.d/default.conf && \ 
nginx -g 'daemon off;'

