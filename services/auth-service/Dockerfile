FROM node:20-alpine AS builder
WORKDIR /services/auth-service
COPY package*.json ./
# Force clean install
ARG CACHEBUST=1
RUN npm ci

COPY . .

# Stage 2: production
FROM node:20-alpine
WORKDIR /services/auth-service
# Bust cache by changing workdir and using npm ci
COPY --from=builder /services/auth-service/package*.json ./
ARG CACHEBUST=1
RUN npm ci --omit=dev
COPY --from=builder /services/auth-service/index.js ./

RUN addgroup -S appgroup && adduser -S appuser -G appgroup
USER appuser

EXPOSE 3001
CMD ["npm", "start"]
