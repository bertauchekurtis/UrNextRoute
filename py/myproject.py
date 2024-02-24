from flask import Flask, request, jsonify, json
from werkzeug.middleware.proxy_fix import ProxyFix
import db
import astar
from helpers import Link, Node
import csv
import geopy.distance

app = Flask(__name__)
app.wsgi_app = ProxyFix(app.wsgi_app, x_for=1, x_host=1)

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

path = astar.find_path(nodes[26],
                nodes[86],
                neighbors_fnct=getNeighbors,
                heuristic_cost_estimate_fnct=getGeoDistance,
                distance_between_fnct=getDistanceBetweenTwoNodes
                )
for p in path:
    print(str(p.lat) + "," + str(p.long) + ",")

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
    pathString += endLat + "," + endLong + ","
    return {
        "path" : pathString,
        "length" : 0,
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
    


if __name__ == "__main__":
    app.run(host='0.0.0.0')