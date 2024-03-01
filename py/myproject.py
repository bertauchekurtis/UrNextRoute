from flask import Flask, request, jsonify
from werkzeug.middleware.proxy_fix import ProxyFix
import db
import datetime
app = Flask(__name__)
app.wsgi_app = ProxyFix(app.wsgi_app, x_for=1, x_host=1)
db.init_db()
@app.route("/")
def home():
    result = db.get_user()
    return f"<h1 style='color:blue'>hello world - db result: {result[1]} {result[2]}</h1>"

@app.route('/json')
def json():
    return {
        "status": "hello world",
        "color": "green",
    }

@app.route('/getrole')
def get_role():
    uuid = request.args.get('uuid', None)
    user = db.get_user_role(uuid)
    if user is not None:
        return {'role': user[2]}
    else:
        db.add_user_role(uuid, "user")
        return {'role': "user"}
    
@app.route('/addpin')
def add_pin():
    uuid = request.args.get('uuid', None)
    type = request.args.get('type', None)
    lat = request.args.get('lat', None)
    long = request.args.get('long', None)

    creationDateString = request.args.get('createDate', None)
    creationDateList = creationDateString.split(',')
    expireDateString = request.args.get('expireDate', None)
    expireDateList = expireDateString.split(',')
    createDate = datetime.datetime(year = int(creationDateList[0]),
                                   month = int(creationDateList[1]),
                                   day = int(creationDateList[2]),
                                   hour = int(creationDateList[3]),
                                   minute = int(creationDateList[4]))
    expireDate = datetime.datetime(year = int(expireDateList[0]),
                                   month = int(expireDateList[1]),
                                   day = int(expireDateList[2]),
                                   hour = int(expireDateList[3]),
                                   minute = int(expireDateList[4]))
    closestBuilding = request.args.get('closestBuilding', None)
    comment = request.args.get('comment', None)
    result = db.add_safety_pin(uuid = uuid,
                      type = int(type),
                      lat = float(lat),
                      long = float(long),
                      createDate = createDate,
                      expireDate = expireDate,
                      closestBuilding = closestBuilding,
                      comment = comment)
    return({"id": result})

@app.route("/getallpins")
def get_all_pins():
    pins = db.get_all_safety_pins()
    return jsonify({"pins": pins})

@app.route("/getpinbyid")
def get_pin_by_id():
    id = request.args.get("id")
    return db.get_safety_pin_by_id(id)

@app.route("/getallpinsofuser")
def get_all_pins_of_user():
    uuid = request.args.get("uuid")
    pins = db.get_all_safety_pins_of_one_user(uuid)
    return jsonify({"pins": pins})

@app.route("/deletepin")
def delete_pin():
    id = request.args.get("id")
    db.delete_pin_by_id(int(id))
    return {"status": "deleted"}

@app.route("/updatepin")
def update_pin():
    uuid = request.args.get('uuid', None)
    type = request.args.get('type', None)
    lat = request.args.get('lat', None)
    long = request.args.get('long', None)
    id = request.args.get('id', None)

    creationDateString = request.args.get('createDate', None)
    creationDateList = creationDateString.split(',')
    expireDateString = request.args.get('expireDate', None)
    expireDateList = expireDateString.split(',')
    createDate = datetime.datetime(year = int(creationDateList[0]),
                                   month = int(creationDateList[1]),
                                   day = int(creationDateList[2]),
                                   hour = int(creationDateList[3]),
                                   minute = int(creationDateList[4]))
    expireDate = datetime.datetime(year = int(expireDateList[0]),
                                   month = int(expireDateList[1]),
                                   day = int(expireDateList[2]),
                                   hour = int(expireDateList[3]),
                                   minute = int(expireDateList[4]))
    closestBuilding = request.args.get('closestBuilding', None)
    comment = request.args.get('comment', None)
    db.update_pin_by_id(id, uuid, type, lat, long, createDate, expireDate, closestBuilding, comment)
    return {"status" : "success"}

if __name__ == "__main__":
    app.run(host='0.0.0.0')