import QtQuick 2.12
import QtLocation 5.12
import QtPositioning 5.12

MapPolyline {
    id: droneTrail
    line.width: 1

    function clearPath(){
        visible = false
        path = []
        visible = true
    }
    function setPath(idInfo,colorInfo,posInfo){
        line.color = colorInfo
        path = dronemodel.getDroneHistory(idInfo)
        droneTrail.addCoordinate(posInfo)
        visible = true
    }

    function updatePath(posInfo){
        droneTrail.addCoordinate(posInfo)
    }
}
