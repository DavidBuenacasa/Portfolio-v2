FROM node:lts AS runtime
WORKDIR /app

COPY . .

RUN npm install --legacy-peer-deps
RUN npm run build

ENV HOST=0.0.0.0
ENV PORT=4321
EXPOSE 4321
# Comando para iniciar la aplicación (usando sintaxis JSON)
CMD ["node", "./dist/server/entry.mjs"]