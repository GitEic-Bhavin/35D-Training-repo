FROM node:latest

WORKDIR /usr/src/app

COPY package*.json ./

RUN npm install

# COPY all things from local directory into container directory .user/src/app
COPY . .

EXPOSE 3000

CMD ["node", "index.js"]