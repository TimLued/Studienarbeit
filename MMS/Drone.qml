import QtQuick 2.12
import QtPositioning 5.12
import QtLocation 5.12
import "algos.js" as Algos
import TransSmoother 1.0

MapQuickItem {
    id: drone
    visible: true

    //property string droneID
    //property int index
    property string droneColor
    property bool marked: false
    property int droneSize: 14

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

}
