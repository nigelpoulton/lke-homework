FROM node:current-alpine

LABEL org.opencontainers.image.title="Hello LKE!" \
      org.opencontainers.image.description="Simple webs erver for LKE demo showing Pod serving web requests" \
      org.opencontainers.image.authors="@nigelpoulton" \
      org.opencontainers.image.vendor="@nigelpoulton"

RUN mkdir -p /usr/src/app

WORKDIR /usr/src/app

COPY package.json /usr/src/app/

RUN npm install

COPY . /usr/src/app

USER node

CMD [ "npm", "start" ]