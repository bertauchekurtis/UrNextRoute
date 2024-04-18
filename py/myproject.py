from flask import Flask, request, jsonify, json
from werkzeug.middleware.proxy_fix import ProxyFix
import db
import astar
from helpers import Link, Node
import csv
import datetime
import geopy.distance
import numpy as np
import bad_words_filter
import pandas as pd
from apscheduler.schedulers.background import BackgroundScheduler

app = Flask(__name__)
app.wsgi_app = ProxyFix(app.wsgi_app, x_for=1, x_host=1)
db.init_db()
scheduler = BackgroundScheduler()
job = scheduler.add_job(db.clear_expired, 'interval', minutes=1)
scheduler.start()

profanity_df = pd.read_csv('profanity_en.csv')
profanity_words = bad_words_filter.open_df(profanity_df)

# Load data
links = []
nodes = []
brightness = []
maxBrightness = 0
minBrigtness = 99999
r = csv.reader(open("./links.csv"))
for item in r:
    brightnessLevel = item[3]
    brightness.append(float(brightnessLevel))

# uniform thing from <>
def uniformize(x, nbins = 1100):
    which = lambda lst:list(np.where(lst)[0])
    gh = np.histogram(x, bins = nbins)
    empirical_cumulative_distribution = np.cumsum(gh[0])/nbins

    ans_x = x
    for idx in range(len(x)):
        max_idx = max(which(gh[1]<x[idx])+[0])
        ans_x[idx] = empirical_cumulative_distribution[max_idx]

    return ans_x


uniformBright = uniformize(np.array(brightness))
r = csv.reader(open("./links.csv"))
for item in zip(r, uniformBright):
    edgeID = item[0][0]
    start_nodeID = item[0][1]
    end_nodeID = item[0][2]
    brightnessLevel = item[0][3]
    startLat = item[0][4]
    startLong = item[0][5]
    endLat = item[0][6]
    endLong = item[0][7]
    isInside = item[0][8]
    blueLight = item[0][9]
    stairs = item[0][10]
    length = item[0][11]

    if float(brightnessLevel) < minBrigtness:
        minBrigtness = float(brightnessLevel)
    if float(brightnessLevel) > maxBrightness:
        maxBrightness = float(brightnessLevel)
    print(type(float(item[1])))

    links.append(Link(edgeID,
                      start_nodeID,
                      end_nodeID,
                      brightnessLevel,
                      (startLat,startLong),
                      (endLat,endLong),
                      isInside,
                      blueLight,
                      stairs,
                      length,
                      float(item[1])
                      )
                )
    
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
linkBrightnessDict = {}
for node in nodes:
    neighborDict[node] = []
    lookUpNodeById[node.nodeId] = node
for link in links:
    neighborDict[lookUpNodeById[link.startID]].append(lookUpNodeById[link.endID])
    neighborDict[lookUpNodeById[link.endID]].append(lookUpNodeById[link.startID])
    linkLengthDict[link.startID + link.endID] = float(link.length)
    linkLengthDict[link.endID + link.startID] = float(link.length)
    #print(link.uniformBright[0])
    linkBrightnessDict[link.startID + link.endID] = float(link.uniformBright[0])
    linkBrightnessDict[link.endID + link.startID] = float(link.uniformBright[0])

def getNeighbors(node):
    return neighborDict[node]

# def getDistanceBetweenTwoNodes(node1, node2):
#     return linkLengthDict[node1.nodeId + node2.nodeId]

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
    sensitivity = request.args.get('sensitivity', None)
    def getDistanceBetweenTwoNodes(node1, node2, sensitivity = sensitivity):
       sensitivity = float(sensitivity)
       baseDistance = linkLengthDict[node1.nodeId + node2.nodeId]
       brightness = linkBrightnessDict[node1.nodeId + node2.nodeId]
       #print(sensitivity, brightness)

       if sensitivity == 0:
           return baseDistance
       else:
           normalizedBrightness = (brightness - 0)/(1.006 - 0)
           oneminus = 1 - normalizedBrightness
           j = 10 - sensitivity
           k = 2 ** j
           scaling = 1 - ((1 - oneminus) ** k)
           #print("Base Distance: ", baseDistance, "\nModified: ", scaling * baseDistance)
           return scaling * baseDistance
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
    sensitivity = request.args.get('sensitivity', None)
    def getDistanceBetweenTwoNodes(node1, node2, sensitivity = sensitivity):
       sensitivity = float(sensitivity)
       baseDistance = linkLengthDict[node1.nodeId + node2.nodeId]
       brightness = linkBrightnessDict[node1.nodeId + node2.nodeId]
       #print(sensitivity, brightness)

       if sensitivity == 0:
           return baseDistance
       else:
           normalizedBrightness = (brightness - 0)/(1.006 - 0)
           oneminus = 1 - normalizedBrightness
           j = 10 - sensitivity
           k = 2 ** j
           scaling = 1 - ((1 - oneminus) ** k)
           #print("Base Distance: ", baseDistance, "\nModified: ", scaling * baseDistance)
           return scaling * baseDistance
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
    email = request.args.get('email', None)
    user = db.get_user_role(uuid)
    if user is not None:
        return {'role': user[2]}
    else:
        db.add_user_role(uuid, "user", email)
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
    currentDate = datetime.datetime.now()
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
    comment = bad_words_filter.process_input(comment)
    bad_words = bad_words_filter.check_description(comment, profanity_words)
    for i in range(len(comment)):
        if comment[i] in bad_words:
            comment[i] = comment[i].replace(comment[i], '*' * len(comment[i]))  
    comment = ' '.join(comment)

    result = db.add_safety_pin(uuid = uuid,
                      type = int(type),
                      lat = float(lat),
                      long = float(long),
                      createDate = createDate,
                      expireDate = expireDate,
                      closestBuilding = closestBuilding,
                      comment = comment)
    #if expireDate < currentDate:
    #    delete_pin()
    return({"id": result})

@app.route("/getuserroles")
def get_all_roles():
    roles = db.get_all_user_roles()
    return jsonify({"roles": roles})

@app.route('/updateroles')
def update_role():
    id = request.args.get("id")
    new_role = request.args.get("new_role")
    db.update_user_role(id, new_role)
    return {"status": "success"}

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
    comment = bad_words_filter.process_input(comment)
    bad_words = bad_words_filter.check_description(comment, profanity_words)
    for i in range(len(comment)):
        if comment[i] in bad_words:
            comment[i] = comment[i].replace(comment[i], '*' * len(comment[i]))  
    comment = ' '.join(comment)
    db.update_pin_by_id(id, uuid, type, lat, long, createDate, expireDate, closestBuilding, comment)
    return {"status" : "success"}

@app.route("/addpath")
def add_path():
    uuid = request.args.get('uuid', None)
    path = request.args.get('path', None)
    result = db.add_favorite_route(uuid, path)
    return jsonify({"id": result})

@app.route("/removepath")
def remove_path():
    id = request.args.get('id', None)
    db.delete_fav_path_by_id(int(id))
    return {"status": "success"}

@app.route('/getallpathsofuser')
def get_all_paths_of_user():
    id = request.args.get('uuid', None)
    paths = db.get_all_favorite_routes_of_one_user(id)
    return jsonify({"paths": paths})

@app.route('/addsettings')
def add_settings():
    uuid = request.args.get('uuid', None)
    blueLights = request.args.get('blueLights', None)
    if blueLights == 'true':
        blueLights = True
    else:
        blueLights = False
    maintenance = request.args.get('maintenance', None)
    if maintenance == 'true':
        maintenance = True
    else:
        maintenance = False
    trip = request.args.get('trip', None)
    if trip == 'true':
        trip = True
    else:
        trip = False
    safety = request.args.get('safety', None)
    if safety == 'true':
        safety = True
    else:
        safety = False
    db.add_settings(uuid, blueLights, maintenance, trip, safety)
    return {"status": "success"}

@app.route("/updatesettings")
def update_settings():
    uuid = request.args.get('uuid', None)
    blueLights = request.args.get('blueLights', None)
    if blueLights == 'true':
        blueLights = True
    else:
        blueLights = False
    maintenance = request.args.get('maintenance', None)
    if maintenance == 'true':
        maintenance = True
    else:
        maintenance = False
    trip = request.args.get('trip', None)
    if trip == 'true':
        trip = True
    else:
        trip = False
    safety = request.args.get('safety', None)
    if safety == 'true':
        safety = True
    else:
        safety = False
    db.update_settings_by_uuid(uuid, blueLights, maintenance, trip, safety)
    return {"status": "success"}

@app.route("/getsettings")
def get_settings():
    uuid = request.args.get('uuid', None)
    sets = db.get_settings_by_uuid(uuid)
    if sets is not None:
        return {"id": sets[0],
                "uuid": sets[1],
                "blueLights": sets[2],
                "maintenance": sets[3],
                "trip": sets[4],
                "safety": sets[5],}
    else:
        db.add_settings(uuid, False, True, True, True)
                                   

if __name__ == "__main__":
    app.run(host='0.0.0.0')