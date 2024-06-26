class Node:
    def __init__(self, nodeId, lat, long, isInside):
        self.nodeId = nodeId
        self.lat = lat
        self.long = long
        self.isInside = isInside

    # see this Stack Overflow post for where we found how to make this object hashable
    # https://stackoverflow.com/questions/2909106/whats-a-correct-and-good-way-to-implement-hash
    def __eq__(self, other):
        if self.lat == other.lat and self.long == other.long:
            return True
        return False
    
    def keyForHash(self):
        return (self.nodeId, self.lat, self.long, self.isInside)
    
    def __hash__(self) -> int:
        return hash(self.keyForHash())
        
class Link:
    def __init__(self, edgeID, startID, endID, brightessLevel, startPos, endPos, isInside, bluelight, stairs, length, uniformBright):
        self.edgeID = edgeID
        self.startID = startID
        self.endID = endID
        self.brightnessLevel = brightessLevel
        self.startPos = startPos
        self.endPos = endPos
        self.isInside = isInside
        self.blueLight = bluelight
        self.stairs = stairs
        self.length = length
        self.uniformBright = uniformBright,