# --- ETAPA 1: Construcción (Build) ---
FROM node:lts-slim AS builder
WORKDIR /app

# Copiamos solo los archivos de dependencias para aprovechar el caché
COPY package*.json ./
RUN npm install --legacy-peer-deps

# Copiamos el resto del código y construimos
COPY . .
RUN npm run build

# --- ETAPA 2: Producción (Runtime) ---
FROM node:lts-slim AS runtime
WORKDIR /app

# Copiamos SOLO los archivos necesarios generados en la etapa anterior
COPY --from=builder /app/dist ./dist
COPY --from=builder /app/package*.json ./

# Instalamos solo las dependencias de producción (omite devDependencies)
RUN npm install --omit=dev --legacy-peer-deps

ENV HOST=0.0.0.0
ENV PORT=4321
EXPOSE 4321

CMD ["node", "./dist/server/entry.mjs"]