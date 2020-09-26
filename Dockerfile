FROM node:alpine as builder

WORKDIR /app

COPY package*.json ./

RUN npm ci

COPY . .

RUN npm run build \
    && npm ci --production

FROM node:alpine as runner

WORKDIR /app

COPY --from=builder /app/package.json ./
COPY --from=builder /app/.next ./.next
COPY --from=builder /app/public ./public
COPY --from=builder /app/node_modules ./node_modules

RUN npx next telemetry disable 

EXPOSE 3000
USER node
CMD "npm" "start"
