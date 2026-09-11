from datetime import datetime

from sqlmodel import Field, SQLModel, create_engine


class Measurement(SQLModel, table=True):
    class Config:
        validate_assignment = True

    timestamp: datetime = Field(default=None, primary_key=True)
    temperature: float
    humidity: float


sqlite_file_name = "database.db"
sqlite_url = f"sqlite:///{sqlite_file_name}"

engine = create_engine(sqlite_url, echo=True)
SQLModel.metadata.create_all(engine)
