FROM node:18-alpine AS builder
WORKDIR /services/auth-service
COPY package*.json ./
RUN npm install
COPY . .

# Stage 2: production
FROM node:18-alpine
WORKDIR /services/auth-service
COPY --from=builder /services/auth-service/package*.json ./
# Only install production dependencies
RUN npm install --omit=dev
COPY --from=builder /services/auth-service/index.js ./

RUN addgroup -S appgroup && adduser -S appuser -G appgroup
USER appuser

EXPOSE 3001
CMD ["npm", "start"]
