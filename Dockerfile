FROM node:alpine as builder

WORKDIR /app

COPY package*.json /app/

RUN npm ci

COPY . .

RUN npx next telemetry disable \
    && npm run build

EXPOSE 3000

CMD "npm" "run" "start"
