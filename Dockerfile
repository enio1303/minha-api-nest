# ==========================
# 1) Stage de Build
# ==========================
FROM node:18-alpine AS builder

WORKDIR /app

# Copiar package.json primeiro para aproveitar cache
COPY package*.json ./

# Instalar dependências
RUN npm install

# Copiar todo o código
COPY . .

# Compilar NestJS (gera dist/)
RUN npm run build


# ==========================
# 2) Stage Final (produção)
# ==========================
FROM node:18-alpine

WORKDIR /app

# Copiar apenas dist e node_modules necessários
COPY package*.json ./

# Instalar apenas dependências de produção
RUN npm install --omit=dev

# Copiar build gerado
COPY --from=builder /app/dist ./dist

# Expor porta padrão NestJS
EXPOSE 3000

# Comando de inicialização
CMD ["node", "dist/main.js"]
