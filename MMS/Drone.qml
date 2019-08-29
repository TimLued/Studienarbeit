import QtQuick 2.12
import QtPositioning 5.12
import QtLocation 5.12
import "algos.js" as Algos

MapQuickItem {
    id: drone
    visible: true

    property string droneId
    property string droneColor
    property int droneSize: 25
    property double bearing
    property bool extrapolating
    property bool extrapolatingAnimation
    property double extrapolationTime
    property bool trackingHistory
    property bool popUp: false

    sourceItem: Item{
        width: droneSize
        height: droneSize

        transform: Rotation {
            origin.x: droneSize/2
            origin.y: droneSize/2
            angle: bearing
            Behavior on angle {
                enabled: !map.droneRotAniLock
                RotationAnimation{
                    id:rotAni
                    duration: 100
                    direction: RotationAnimation.Shortest
                    easing.type: Easing.Linear
                }
            }
        }
        MouseArea{
            anchors.fill: parent
            onClicked: popUp = !popUp
        }
        Rectangle{
            id: droneRect
            anchors.fill: parent
            radius: droneSize/2
            color: "white"
            opacity: 0.7
        }
        Text{
            y: -7
            anchors.horizontalCenter: droneRect.horizontalCenter
            text: "\u2B9D"
            font.pixelSize: 25
            color: droneColor
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
        }
    }


    Behavior on coordinate {
        id:smoother
        enabled: extrapolatingAnimation
        CoordinateAnimation{
            easing.type: Easing.Linear
            duration: extrapolationTime
        }
    }


    anchorPoint.x: droneSize/2
    anchorPoint.y: droneSize/2
}
