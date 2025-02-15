# Etapa base
FROM node:20-alpine AS base
WORKDIR /app

# Copiar solo los archivos de dependencias
COPY package.json package-lock.json ./

# Instalar dependencias de producción
FROM base AS prod-deps
RUN npm install --omit=dev

# Instalar todas las dependencias
FROM base AS build-deps
RUN npm install

# Copiar el código fuente y construir la aplicación
FROM build-deps AS build
COPY . .
RUN npm run build

# Etapa de runtime
FROM base AS runtime
COPY --from=prod-deps /app/node_modules ./node_modules
COPY --from=build /app/dist ./dist

# Configurar variables de entorno
ENV HOST=0.0.0.0
ENV PORT=4321

# Exponer el puerto
EXPOSE 4321

# Comando para iniciar la aplicación
CMD ["node", "./dist/server/entry.mjs"]
