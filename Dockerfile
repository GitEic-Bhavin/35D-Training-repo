FROM nginx:alpine

# RUN apt-get update
COPY index.html /usr/share/nginx/html/index.html


EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]