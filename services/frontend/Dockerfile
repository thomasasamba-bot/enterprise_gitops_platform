FROM node:18-alpine AS base

FROM base AS deps
WORKDIR /services/frontend
COPY package.json package-lock.json* ./
ARG CACHEBUST=1
RUN npm ci

FROM base AS builder
WORKDIR /services/frontend
COPY --from=deps /services/frontend/node_modules ./node_modules
COPY . .
RUN npm run build

FROM base AS runner
WORKDIR /services/frontend
ENV NODE_ENV production
COPY --from=builder /services/frontend/public ./public
COPY --from=builder /services/frontend/.next/static ./.next/static
COPY --from=builder /services/frontend/.next/standalone ./

RUN addgroup -S appgroup && adduser -S appuser -G appgroup
USER appuser

EXPOSE 3000
ENV PORT 3000
CMD ["node", "server.js"]
