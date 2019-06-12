import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Window 2.12
import QtPositioning 5.12
import QtLocation 5.12
import "algos.js" as Algos

ApplicationWindow  {
    id: win
    visible: true
    title: "MMS GUI"
    width: 800
    height: 500


    property variant usedColors: []

    property int txtSize: 14
    property int enlarged: 200
    property int small: txtSize + 15

    property int btnSize: 40

    Map{
        id: map
        anchors.fill:parent
        plugin: Plugin{name:"mapboxgl"}
        center: QtPositioning.coordinate(54.3107,10.1291)
        zoomLevel: 14


        //MAP SCALE
        property variant scaleLengths: [5, 10, 20, 50, 100, 200, 500, 1000, 2000, 5000, 10000, 20000, 50000, 100000, 200000, 500000, 1000000, 2000000]

        function calculateScale(objWidth)
        {
            var coord1, coord2, dist, f
            var info = []

            f = 0 //factor
            coord1 = map.toCoordinate(Qt.point(0,scale.y))
            coord2 = map.toCoordinate(Qt.point(objWidth,scale.y))

            dist = Math.round(coord1.distanceTo(coord2))

            if (dist === 0) {
                // not visible
            } else {
                for (var i = 0; i < scaleLengths.length-1; i++) {
                    if (dist < (scaleLengths[i] + scaleLengths[i+1]) / 2 ) {
                        f = scaleLengths[i] / dist
                        dist = scaleLengths[i]
                        break;
                    }
                }
                if (f === 0) {
                    f = dist / scaleLengths[i]
                    dist = scaleLengths[i]
                }
            }

            info.push(Algos.formatDistance(dist))
            info.push(f)
            return info
        }

        function setZoomScale(){

            scaleText.text = info[0]
            scaleImage.width = (scaleImage.sourceSize.width * info[1]) - 2 * scaleImageLeft.sourceSize.width
        }

        function setCircleScale(){
            var info = calculateScale(scaleImage.sourceSize.width)
            //RADIUS
        }


        onZoomLevelChanged:{
            map.setZoomScale()
            zoomLbl.text = "Zoom: " + Math.round(map.zoomLevel)
        }

        Item {
            id: scale
            z: map.z + 3
            visible: scaleText.text != "0 m"
            anchors.bottom: parent.bottom;
            anchors.right: parent.right
            anchors.margins: 20
            height: scaleText.height * 2
            width: scaleImage.width

            Image {
                id: scaleImageLeft
                source: "img/scale_end.png"
                anchors.bottom: parent.bottom
                anchors.right: scaleImage.left
            }
            Image {
                id: scaleImage
                source: "img/scale.png"
                anchors.bottom: parent.bottom
                anchors.right: scaleImageRight.left
            }
            Image {
                id: scaleImageRight
                source: "img/scale_end.png"
                anchors.bottom: parent.bottom
                anchors.right: parent.right
            }
            Label {
                id: scaleText
                color: "#004EAE"
                anchors.centerIn: parent
                text: "0 m"
            }
            Component.onCompleted: {
                map.setZoomScale();
            }
        }

        Item{
            id: infobar
            z: 3
            anchors.top: parent.top
            anchors.right: parent.right
            anchors.margins: 20
            height: zoomLbl.height * 2
            width: 72

            //Zoom Label
            Label {
                id: zoomLbl
                color: "#004EAE"
                anchors.left: parent.left
            }

            //Coordinate Label
            Label {
                id: coorLbl
                color: "#004EAE"
                text: "" //updates on mouse moved on map
                anchors.top:zoomLbl.bottom
                anchors.left: parent.left
            }
        }

        MouseArea{
            anchors.fill: parent
            hoverEnabled: true

            property variant cor
            onPositionChanged: {
                cor = map.toCoordinate(Qt.point(mouse.x, mouse.y))
                coorLbl.text = Algos.roundNumber(cor.latitude,3) + ", " +  Algos.roundNumber(cor.longitude,3)
            }

        }

        PolyLine {id: staticPath}
        PolyLine{id: dynamicPath}

        function updateStaticPath(idInfo,colorInfo,posInfo){
            staticPath.setPath(idInfo,colorInfo,posInfo)
            dynamicPath.line.color = colorInfo
        }

        function removeTrail(){
            staticPath.clearPath()
            dynamicPath.clearPath()
        }


        MapItemView{
            model: dronemodel
            delegate: Drone{
                coordinate: posInfo
                droneColor: colorInfo
                onCoordinateChanged: {
                    if (followInfo) dynamicPath.updatePath(posInfo)
                }
            }
        }

//        MapItemView {
//            model: nodemodel
//            delegate: ArrowItem{
//                coordinate: nodeData
//                transformOrigin: Item.Center
//                rotation: angleData
//                z:100
//                factor: mapOfWorld.zoomLevel
//            }
//

        //TRANSMITTER (add cpp in MMS)/// Receiver for action handling -> back to PosSource
        /*
        -Waypoint (1 coor)
        -Rectangle (4 coordinates) U+20DE
        -Triangle U+20E4
        -Circle (how many coordinate?)  U+20DD
        -x points area (closed, transp color)
        SELECT Drones (RoundBtn change Text in Panel {visible}) U+2713
        ADDITONAL data (per drone / adept btn
        - perform when? {ComboBox}
        - priority?
        - side task?
        TRANSMITTER SEND Coors to SERVER
        */


    }

    DronePanel{id:dronePanel}

    ActionPanel{id:actionPanel}
}

