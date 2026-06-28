# ---- Build stage: compile the React app to static files ----
FROM node:22-alpine AS build
WORKDIR /app

# Install deps first (cached unless package files change).
COPY package*.json ./
RUN npm ci

COPY . .
RUN npm run build

# ---- Serve stage: static files behind nginx ----
FROM nginx:1.27-alpine AS runtime

# Our server config (SPA fallback + /api proxy) replaces the default.
COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY --from=build /app/dist /usr/share/nginx/html

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
