FROM node:18-alpine AS builder
WORKDIR /services/auth-service
COPY package*.json ./
# Determinstic build
RUN npm ci

COPY . .

# Stage 2: production
FROM node:18-alpine
WORKDIR /services/auth-service
# Bust cache by changing workdir and using npm ci
COPY --from=builder /services/auth-service/package*.json ./
RUN npm ci --omit=dev
COPY --from=builder /services/auth-service/index.js ./

RUN addgroup -S appgroup && adduser -S appuser -G appgroup
USER appuser

EXPOSE 3001
CMD ["npm", "start"]
