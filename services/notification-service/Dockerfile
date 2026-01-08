FROM ruby:3.2-alpine AS builder

WORKDIR /services/notification-service

# Install build dependencies for native gems
RUN apk add --no-cache build-base

COPY Gemfile ./
RUN bundle install

FROM ruby:3.2-alpine

WORKDIR /services/notification-service

# Patch OS vulnerabilities and install runtime essentials
RUN apk upgrade --no-cache && \
    apk add --no-cache curl

# Copy gems from builder
COPY --from=builder /usr/local/bundle /usr/local/bundle
COPY . .

# Security: Run as non-root user
RUN addgroup -S appgroup && adduser -S appuser -G appgroup
USER appuser

EXPOSE 4567

CMD ["ruby", "app.rb"]
