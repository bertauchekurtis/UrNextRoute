import sqlalchemy
from sqlalchemy import Table, Column, Integer, String, insert, select, DateTime, Float, delete, update, Double, VARCHAR, func, TEXT, Boolean
# note that the password in this file is not the password used on the server, github actions will auto fill that
engine = sqlalchemy.create_engine("mariadb+mariadbconnector://root@127.0.0.1:3306/urnextroute")
metadata_obj = sqlalchemy.MetaData()

# This table (lines 9-15) is an example and came from
# https://docs.sqlalchemy.org/en/20/tutorial/metadata.html
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
    Column("email", VARCHAR(200)),
)
safety_pin = Table(
    "safety_pin",
    metadata_obj,
    Column("id", Integer, primary_key = True),
    Column("uuid", String(28)),
    Column("type", Integer),
    Column("latitude", Double),
    Column("longitude", Double),
    Column("creationDate", DateTime),
    Column("expirationDate", DateTime),
    Column("closestBuilding", String(120)),
    Column("comment", String(120)),
)

fav_paths = Table(
    "fav_paths",
    metadata_obj,
    Column("id", Integer, primary_key = True),
    Column("uuid", String(28)),
    Column("path", TEXT(50000))
)

settings = Table(
    "settings",
    metadata_obj,
    Column("id", Integer, primary_key= True),
    Column("uuid", String(28)),
    Column("blueLights", Boolean),
    Column("maintenance", Boolean),
    Column("trip", Boolean),
    Column("safety", Boolean),
)

def init_db():
    with engine.connect() as conn:
        metadata_obj.create_all(bind = engine)
# This is an example (lines 62 - 67) from SQLAlchemy documentation:
# https://docs.sqlalchemy.org/en/20/tutorial/data_insert.html#tutorial-core-insert
def add_user():
    stmt = insert(user_table).values(name = "spongebob", fullname = "Spongebob Squarepants")
    compiled = stmt.compile()
    with engine.connect() as conn:
        result = conn.execute(stmt)
        conn.commit()
# This function is an example (lines 69 - 75) from SQLAlchemy documentation
# https://docs.sqlalchemy.org/en/20/tutorial/data_select.html
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

def add_user_role(uuid, role, email):
    stmt = insert(user_role).values(uuid = uuid, role = role, email = email)
    with engine.connect() as conn:
        result = conn.execute(stmt)
        conn.commit()

def get_all_user_roles():
    stmt = select(user_role)
    with engine.connect() as conn:
        result = []
        for row in conn.execute(stmt):
            result.append({"id": row[0],
                           "uuid": row[1],
                           "role": row[2],
                           "email": row[3],})
        return result
    
def update_user_role(id, new_role):
    stmt = update(user_role).where(user_role.c.id == id).values(role = new_role)
    with engine.connect() as conn:
        result = conn.execute(stmt)
        conn.commit()
        
def clear_expired():
    stmt = delete(safety_pin).where(safety_pin.c.expirationDate < func.now())
    with engine.connect() as conn:
        result = conn.execute(stmt)
        conn.commit()
def add_safety_pin(uuid, type, lat, long, createDate, expireDate, closestBuilding, comment):
    stmt = insert(safety_pin).values(uuid = uuid, 
                                     type = type, 
                                     latitude = lat,
                                     longitude = long,
                                     creationDate = createDate,
                                     expirationDate = expireDate,
                                     closestBuilding = closestBuilding,
                                     comment = comment)
    with engine.connect() as conn:
        result = conn.execute(stmt)
        newId = result.lastrowid
        conn.commit()
    return newId

def get_safety_pin_by_id(id):
    stmt = select(safety_pin).where(safety_pin.c.id == id)
    with engine.connect() as conn:
        result = conn.execute(stmt)
        pin = result.first()
        return {"id": pin[0],
                "uuid": pin[1],
                "type": pin[2],
                "lat": pin[3],
                "long": pin[4],
                "createDate": pin[5],
                "expireDate": pin[6],
                "closestBuilding": pin[7],
                "comment": pi[8]}

def get_all_safety_pins():
    stmt = select(safety_pin)
    with engine.connect() as conn:
        result = []
        for row in conn.execute(stmt):
            result.append({"id": row[0],
                           "uuid": row[1],
                           "type": row[2],
                           "lat": row[3],
                           "long": row[4],
                           "createDate": row[5],
                           "expireDate": row[6],
                           "closestBuilding": row[7],
                           "comment": row[8]})
        return result
    
def get_all_safety_pins_of_one_user(uuid):
    stmt = select(safety_pin).where(safety_pin.c.uuid == uuid)
    with engine.connect() as conn:
        result = []
        for row in conn.execute(stmt):
            result.append({"id": row[0],
                           "uuid": row[1],
                           "type": row[2],
                           "lat": row[3],
                           "long": row[4],
                           "createDate": row[5],
                           "expireDate": row[6],
                           "closestBuilding": row[7],
                           "comment": row[8]})
        return result
    
def delete_pin_by_id(id):
    stmt = delete(safety_pin).where(safety_pin.c.id == id)
    with engine.connect() as conn:
        conn.execute(stmt)
        conn.commit()

def update_pin_by_id(id, uuid, type, lat, long, createDate, expireDate, closestBuilding, comment):
    stmt = update(safety_pin).where(safety_pin.c.id == id).values(uuid = uuid, 
                                     type = type, 
                                     latitude = lat,
                                     longitude = long,
                                     creationDate = createDate,
                                     expirationDate = expireDate,
                                     closestBuilding = closestBuilding,
                                     comment = comment)
    with engine.connect() as conn:
        result = conn.execute(stmt)
        conn.commit()

def add_favorite_route(uuid, path):
    stmt = insert(fav_paths).values(uuid = uuid,
                                    path = path)    
    with engine.connect() as conn:
        result = conn.execute(stmt)
        newId = result.lastrowid
        conn.commit()
    return newId

def get_all_favorite_routes():
    stmt = select(fav_paths)
    with engine.connect() as conn:
        result = []
        for row in conn.execute(stmt):
            result.append({"id": row[0],
                           "uuid": row[1],
                           "path": row[2],})
        return result
    
def get_all_favorite_routes_of_one_user(uuid):
    stmt = select(fav_paths).where(fav_paths.c.uuid == uuid)
    with engine.connect() as conn:
        result = []
        for row in conn.execute(stmt):
            result.append({"id": row[0],
                           "uuid": row[1],
                           "path": row[2],})
        return result
    
def delete_fav_path_by_id(id):
    stmt = delete(fav_paths).where(fav_paths.c.id == id)
    with engine.connect() as conn:
        conn.execute(stmt)
        conn.commit()

def add_settings(uuid, blueLights, maintenance, trip, safety):
    stmt = insert(settings).values(uuid = uuid, 
                                     blueLights = blueLights,
                                     maintenance = maintenance,
                                     trip = trip,
                                     safety = safety,
                                     )
    with engine.connect() as conn:
        result = conn.execute(stmt)
        newId = result.lastrowid
        conn.commit()
    return newId

def get_settings_by_uuid(uuid):
    stmt = select(settings).where(settings.c.uuid == uuid)
    with engine.connect() as conn:
        result = conn.execute(stmt)
        sets = result.first()
        if sets is None:
            return None
        return sets

def update_settings_by_uuid(uuid, blueLights, maintenance, trip, safety):
    stmt = update(settings).where(settings.c.uuid == uuid).values(
                                     blueLights = blueLights, 
                                     maintenance = maintenance,
                                     trip = trip,
                                     safety = safety,
                                    )
    with engine.connect() as conn:
        result = conn.execute(stmt)
        conn.commit()

