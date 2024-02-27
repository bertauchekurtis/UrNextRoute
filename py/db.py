import sqlalchemy
from sqlalchemy import Table, Column, Integer, String, insert, select
# note that the password in this file is not the password used on the server, github actions will auto fill that
engine = sqlalchemy.create_engine("mariadb+mariadbconnector://root@127.0.0.1:3306/urnextroute")
metadata_obj = sqlalchemy.MetaData()

user_table = Table(
    "user_account",
    metadata_obj,
    Column("id", Integer, primary_key = True),
    Column("name", String(30)),
    Column("fullname", String(80)),
)
user_role = Table(
    "user_role",
    metadata_obj,
    Column("id", Integer, primary_key = True),
    Column("uuid", String(28)),
    Column("role", String(20)),
)
def init_db():
    with engine.connect() as conn:
        metadata_obj.create_all(bind = engine)

def add_user():
    stmt = insert(user_table).values(name = "spongebob", fullname = "Spongebob Squarepants")
    compiled = stmt.compile()
    with engine.connect() as conn:
        result = conn.execute(stmt)
        conn.commit()

def get_user():
    stmt = select(user_table).where(user_table.c.name == "spongebob")
    with engine.connect() as conn:
        result = []
        for row in conn.execute(stmt):
            result.append(row)
        return result[0]
    
def get_user_role(uid):
    stmt = select(user_role).where(user_role.c.uuid == uid)
    with engine.connect() as conn:
        result = conn.execute(stmt)

        return result.first()

def add_user_role(uuid, role):
    stmt = insert(user_role).values(uuid = uuid, role = role)
    with engine.connect() as conn:
        result = conn.execute(stmt)
        conn.commit()