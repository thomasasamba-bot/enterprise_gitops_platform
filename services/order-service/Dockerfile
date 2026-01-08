FROM python:3.11-slim
WORKDIR /services/order-service
COPY requirements.txt .
RUN apt-get update && apt-get upgrade -y && \
    pip install --no-cache-dir -r requirements.txt
COPY . .

RUN groupadd -r appgroup && useradd -r -g appgroup appuser
USER appuser

EXPOSE 8000
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]
