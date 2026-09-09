from fastapi import FastAPI

from models import Measurement, engine

app = FastAPI()


@app.get("/")
async def root():
    return {"message": "Hello World"}


@app.post("/data")
async def receive_data(measurement: Measurement):
    pass
