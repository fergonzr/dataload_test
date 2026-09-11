#!/usr/bin/env python3
import logging
from datetime import datetime
from typing import Annotated

from fastapi import Depends, FastAPI
from sqlmodel import Session

from .models import Measurement, engine

logging.basicConfig(
    level=logging.INFO,
)

logger = logging.getLogger(__name__)

app = FastAPI()


@app.get("/")
async def root():
    return {"message": "Hello World"}


def get_session():
    with Session(engine) as session:
        yield session


SessionDep = Annotated[Session, Depends(get_session)]


@app.post("/data")
async def receive_data(measurement: Measurement, session: SessionDep) -> Measurement:
    logger.info(measurement.timestamp.__class__)
    session.add(measurement)
    session.commit()
    session.refresh(measurement)
    return measurement
