FROM node:18-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .

# Stage 2: production
FROM node:18-alpine
WORKDIR /app
COPY --from=builder /app/package*.json ./
# Only install production dependencies
RUN npm install --omit=dev
COPY --from=builder /app/index.js ./

RUN addgroup -S appgroup && adduser -S appuser -G appgroup
USER appuser

EXPOSE 3001
CMD ["npm", "start"]
