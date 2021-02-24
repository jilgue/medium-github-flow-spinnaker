FROM node:15-buster-slim
MAINTAINER César M. Cristóbal <cesar@callepuzzle.com>

WORKDIR /app

EXPOSE 3000

COPY index.js index.js
COPY package.json package.json

RUN yarn install

CMD [ "node", "index.js" ]
