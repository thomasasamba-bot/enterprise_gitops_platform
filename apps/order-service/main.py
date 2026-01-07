from fastapi import FastAPI
from pydantic import BaseModel

app = FastAPI()

class Order(BaseModel):
    product: str
    amount: int
    user: str

orders = []

@app.get("/health")
def health_check():
    return {"status": "UP", "service": "order-service"}

@app.get("/orders")
def get_orders():
    return orders

@app.post("/orders")
def create_order(order: Order):
    orders.append(order)
    return {"message": "Order created", "order": order}
