FROM ruby:3.2-alpine

WORKDIR /services/notification-service

# Install build dependencies for native gems (if needed in future)
# RUN apk add --no-cache build-base

COPY Gemfile ./
RUN bundle install

COPY . .

# Security: Run as non-root user
RUN addgroup -S appgroup && adduser -S appuser -G appgroup
USER appuser

EXPOSE 4567

CMD ["ruby", "app.rb"]
