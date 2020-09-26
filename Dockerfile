FROM node:alpine as builder

WORKDIR /app

COPY package*.json ./

RUN npm ci

COPY . .

RUN npx next telemetry disable \
    && npm run build \
    && npm ci --production

FROM node:alpine as runner

WORKDIR /app

COPY --from=builder /app/package.json ./
COPY --from=builder /app/.next ./.next
COPY --from=builder /app/public ./public
COPY --from=builder /app/node_modules ./node_modules

EXPOSE 3000
USER node
CMD "npm" "run" "start"
