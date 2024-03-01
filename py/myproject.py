from flask import Flask, request, jsonify, json
from werkzeug.middleware.proxy_fix import ProxyFix
import db
import astar
from helpers import Link, Node
import csv
import datetime
import geopy.distance

app = Flask(__name__)
app.wsgi_app = ProxyFix(app.wsgi_app, x_for=1, x_host=1)
db.init_db()

# Load data
links = []
nodes = []
r = csv.reader(open("./links.csv"))
for item in r:
    edgeID = item[0]
    start_nodeID = item[1]
    end_nodeID = item[2]
    brightnessLevel = item[3]
    startLat = item[4]
    startLong = item[5]
    endLat = item[6]
    endLong = item[7]
    isInside = item[8]
    blueLight = item[9]
    stairs = item[10]
    length = item[11]

    links.append(Link(edgeID,
                      start_nodeID,
                      end_nodeID,
                      brightnessLevel,
                      (startLat,startLong),
                      (endLat,endLong),isInside,blueLight,
                                stairs,length))
    
# Load nodes
r = csv.reader(open("./nodes.csv"))
for item in r:
    nodeId = item[0]
    lat = item[1]
    long = item[2]
    isInside = item[3]
    nodes.append(Node(nodeId, lat, long, isInside))

neighborDict = {}
lookUpNodeById = {}
linkLengthDict = {}
for node in nodes:
    neighborDict[node] = []
    lookUpNodeById[node.nodeId] = node
for link in links:
    neighborDict[lookUpNodeById[link.startID]].append(lookUpNodeById[link.endID])
    neighborDict[lookUpNodeById[link.endID]].append(lookUpNodeById[link.startID])
    linkLengthDict[link.startID + link.endID] = float(link.length)
    linkLengthDict[link.endID + link.startID] = float(link.length)

def getNeighbors(node):
    return neighborDict[node]

def getDistanceBetweenTwoNodes(node1, node2):
    return linkLengthDict[node1.nodeId + node2.nodeId]

def getGeoDistance(current, goal):
    posOne = (current.lat, current.long)
    posTwo = (goal.lat, goal.long)
    return geopy.distance.geodesic(posOne, posTwo).meters

def getClosestNode(lat, long):
    currentClosestNode = nodes[0]
    distance = 999
    for node in nodes:
        thisDistance = geopy.distance.geodesic((lat, long), (node.lat, node.long)).meters
        if(thisDistance < distance):
            distance = thisDistance
            currentClosestNode = node
    return currentClosestNode
  
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

# example request: https://www.urnextroute.link/getroute?startLat=119&startLong=24&endLat=119&endLong=32
@app.route("/getroute")
def getRoute():
    startLat = request.args.get('startLat', None)
    startLong = request.args.get('startLong', None)
    endLat = request.args.get('endLat', None)
    endLong = request.args.get('endLong', None)
    startingNode = getClosestNode(float(startLat), float(startLong))
    endingNode = getClosestNode(float(endLat), float(endLong))
    path = astar.find_path(startingNode, 
                           endingNode, 
                           neighbors_fnct=getNeighbors, 
                           heuristic_cost_estimate_fnct=getGeoDistance, 
                           distance_between_fnct=getDistanceBetweenTwoNodes)
    pathString = startLat + "," + startLong + ","
    for node in path:
        pathString += str(node.lat) + "," + str(node.long) + ","
    pathString += endLat + "," + endLong
    return {
        "path" : pathString,
        "length" : 0.0,
    }

# for testing paths easily without the frontend (paste the result into a line plotter)
@app.route("/getroutehtml")
def getRouteHTML():
    startLat = request.args.get('startLat', None)
    startLong = request.args.get('startLong', None)
    endLat = request.args.get('endLat', None)
    endLong = request.args.get('endLong', None)
    startingNode = getClosestNode(float(startLat), float(startLong))
    endingNode = getClosestNode(float(endLat), float(endLong))
    path = astar.find_path(startingNode, 
                           endingNode, 
                           neighbors_fnct=getNeighbors, 
                           heuristic_cost_estimate_fnct=getGeoDistance, 
                           distance_between_fnct=getDistanceBetweenTwoNodes)
    pathString = "<p>" + startLat + "," + startLong + "," + "<br>"
    for node in path:
        pathString += str(node.lat) + "," + str(node.long) + "," + "<br>"
    pathString += endLat + "," + endLong + "," + "</p>"
    return pathString
    
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