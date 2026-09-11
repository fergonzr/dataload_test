import os

from sqlmodel import create_engine

database_driver = os.environ["DB_DRIVER"] or "sqlite"

match database_driver:
    case "sqlite":
        database_connector = "sqlite"
    case "mariadb":
        database_connector = "mariadb+pymysql"
    case _:
        database_connector = "sqlite"

database_password = os.environ["DB_PASS"] or "secretpassword"
database_user = os.environ["DB_USER"] or "dataload_test"
database_name = os.environ["DB_NAME"] or "dataload_test"
database_port = os.environ["DB_PORT"] or "3306"
database_host = os.environ["DB_HOST"] or "database"


database_url = (
    f"{database_connector}:///{database_name}.db"
    if database_driver == "sqlite"
    else f"{database_connector}://{database_user}:{database_password}@{database_host}:{database_port}/{database_name}"
)

engine = create_engine(database_url, echo=True)
