import QtQuick 2.12
import QtPositioning 5.12
import QtLocation 5.12
import "algos.js" as Algos
import TransSmoother 1.0

MapQuickItem {
    id: drone
    visible: true

    property string droneID
    property int index
    property string droneColor

    property bool follow: false //map center on drone
    property bool pathPoly: false
    property bool marked: false

    property int droneSize: 14

    property variant lastPos
    property variant lastLastPos
    property date lastTimestamp
    property double speed: 0

    //insted of Rectangle TEXTFIEL??? U+2B9D
    sourceItem: Rectangle{ width: droneSize; height: droneSize; color: droneColor; smooth: true; radius: droneSize/2;}
    anchorPoint.x: droneSize/2
    anchorPoint.y: droneSize/2

    MouseArea{
        anchors.fill: parent
        hoverEnabled: true

        onEntered: {
            droneSize = 17
        }

        onExited: {
            if (!marked) droneSize = 14
        }

        onClicked: {
            marked = !marked
            if (!marked) droneSize = 14
        }
    }

    //update coordinate
    property int interval: 10
    Connections{
        target: Listener
        onPosUpdated: {
            if (droneID === droneInfo){

                smoothThread.stop()
                idleUpdate = false

                lastLastPos = lastPos
                lastPos = pos

                coordinate = lastPos

                if (lastLastPos){
                    //speed = lastPos.distanceTo(lastPos)/(timestamp - lastTimestamp) * 1000
                    //for test cases timestamp difference HERE 20ms
                    speed = lastLastPos.distanceTo(lastPos)/(20) * 1000

                    var bear = Algos.bearing(lastLastPos.latitude,lastLastPos.longitude,lastPos.latitude,lastPos.longitude)
                    var dist = interval/1000*speed
                    smoothThread.start(interval,dist,bear,coordinate)
                }
                lastTimestamp = timestamp
            }
        }
    }
    property bool idleUpdate: false
    Behavior on coordinate{
        enabled: idleUpdate
        CoordinateAnimation{
           duration: interval
           easing.type: Easing.Linear
        }
    }

    onCoordinateChanged: {
        if (follow) map.center = coordinate
        map.posChanged(index,coordinate.latitude,coordinate.longitude,speed)

        if (pathPoly) map.addLine(coordinate,droneColor)

        //ADD
        //INFO last pos update -> millisecs ago
        //GET Mission {new entry} --> Number Code
    }

    TransSmoother{
        id: smoothThread
        onPosUpdate: {
            idleUpdate = true
            coordinate = cor
        }
    }


}
