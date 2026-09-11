from datetime import datetime

from pydantic.types import AwareDatetime
from sqlmodel import Field, SQLModel

from .context import engine


class Measurement(SQLModel, table=True):
    class Config:
        validate_assignment = True

    timestamp: datetime = Field(default=None, primary_key=True)
    temperature: float
    humidity: float


SQLModel.metadata.create_all(engine)
