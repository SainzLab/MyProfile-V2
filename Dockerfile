# Tahap 1: Build aplikasi Vue.js
FROM node:20-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
RUN npm run build

# Tahap 2: Serve dengan Nginx
FROM nginx:stable-alpine
# Hapus default file Nginx
RUN rm -rf /usr/share/nginx/html/*
# Copy hasil build dari Tahap 1
COPY --from=builder /app/dist /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
