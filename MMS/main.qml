import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Window 2.12
import QtPositioning 5.12
import QtLocation 5.12
import "algos.js" as Algos

Window {
    id: win
    visible: true
    //visibility: "Maximized"
    title: "MMS GUI"
    width: 800
    height: 500

    property variant drones: []
    property variant lines: []
    property variant colors: ["Red","Blue","Green","Purple","Yellow"]
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
        function calculateScale()
        {
            var coord1, coord2, dist, text, f
            f = 0
            coord1 = map.toCoordinate(Qt.point(0,scale.y))
            coord2 = map.toCoordinate(Qt.point(0+scaleImage.sourceSize.width,scale.y))
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

            text = Algos.formatDistance(dist)
            scaleImage.width = (scaleImage.sourceSize.width * f) - 2 * scaleImageLeft.sourceSize.width
            scaleText.text = text
        }

        onCenterChanged:{
            scaleTimer.restart()
        }

        onZoomLevelChanged:{
            scaleTimer.restart()
        }

        onWidthChanged:{
            scaleTimer.restart()
        }

        onHeightChanged:{
            scaleTimer.restart()
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
                map.calculateScale();
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
                text: ""
                anchors.top:zoomLbl.bottom
                anchors.left: parent.left
            }
        }

        Timer {
            id: scaleTimer
            interval: 100
            running: false
            repeat: false
            onTriggered: {
                map.calculateScale()
                zoomLbl.text = "Zoom: " + Math.round(map.zoomLevel)
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

            onClicked: {
                for (var i = 0; i<drones.length;i++){
                    drones[i].marked = false
                    drones[i].droneSize = 14
                }
            }
        }

        //register Drones
        Connections{
            target: Listener

            property bool found: false
            onPosUpdated: {
                //drone already exists?
                found = false
                for (var i = 0; i < drones.length; i++) {
                    if (drones[i].droneID === droneInfo){

                        //update loc and speed in panel

                        dronePanel.posChanged(i, pos.latitude, pos.longitude, drones[i].speed)

                        if (drones[i].pathPoly){
                            if (line.pathLength() >= 300) line.removeCoordinate(0)
                            line.addCoordinate(pos)
                            line.line.color = drones[i].droneColor
                        }
                        //INFO last pos update -> millisecs ago
                        //GET Mission {new entry} --> Number Code
                        found = true
                        break
                    }
                }

                if (!found){//NEW drone
                    var drone = Qt.createQmlObject("Drone {}", map)

                    if (usedColors.length == colors.length) usedColors = []
                    for (var k = 0; k<colors.length;k++){
                        if (usedColors.indexOf(colors[k]) == -1){
                            drone.droneColor = colors[k]
                            usedColors.push(colors[k])
                            //update Panel
                            dronePanel.addItem(droneInfo,colors[k])
                            break
                        }
                    }

                    drone.droneID = droneInfo
                    drone.index = drones.length
                    drone.coordinate = pos

                    drones.push(drone)
                    map.addMapItem(drone)
                }

            }
        }

        MapPolyline{
            id: line
            line.width: 2
            opacity: 0.6
            smooth: true
            function clearPath(){
                var pl = pathLength()
                for (var l = 0; l< pl;l++) removeCoordinate(0)
            }
        }

        //Drone PANEL
        Item{
            id: dronePanel
            width: 150
            height: parent.height


            Rectangle{
                width: parent.width
                height: parent.height
                opacity: 0.7
                color: "Grey"
            }

            ListModel{id: droneModel}

            Component{
                id: listDelegate
                Item{
                    id: listItem
                    width: parent.width
                    height: small

                    Rectangle{
                        anchors.fill: parent
                        opacity: 0.3
                        color: droneColor

                        MouseArea {
                            hoverEnabled: true
                            anchors.fill: parent

                            onClicked: {
                                if(listItem.height === small){listItem.height = enlarged
                                }else{listItem.height = small}
                            }

                            onEntered: {
                                list.currentIndex = index
                            }
                            onExited: {
                                list.currentIndex = -1
                            }

                        }
                    }

                    Column{
                        layer.enabled: true
                        spacing: 5
                        anchors.fill: parent
                        anchors.leftMargin: 10
                        anchors.rightMargin: 10
                        anchors.topMargin: 5
                        anchors.bottomMargin: 5

                        Text{text: droneID; font.pixelSize: txtSize; font.underline: drones[index].marked; font.bold: drones[index].marked; wrapMode: Text.WordWrap; width: parent.width}
                        Text{text: "Lat: " + lat; font.pixelSize: txtSize; wrapMode: Text.WordWrap; width: parent.width}
                        Text{text: "Lon: " + lon; font.pixelSize: txtSize; wrapMode: Text.WordWrap; width: parent.width}
                        Text{text: "Speed: " + speed + " m/s"; font.pixelSize: txtSize; wrapMode: Text.WordWrap; width: parent.width}
                        Text{text: "Mission: Transition"; font.pixelSize: txtSize; wrapMode: Text.WordWrap; width: parent.width}

                        Row{
                            spacing: 5
                            Button{
                                //\u2295
                                //\u2A01
                                //\u2B99
                                text: "Follow"
                                height: 20
                                width: 50
                                font.pixelSize: 11
                                highlighted: drones[index].follow
                                enabled: if(listItem.height === enlarged){true}else{false}

                                onClicked:{
                                    if (drones[index].follow){
                                        drones[index].follow = false
                                    }else{
                                        for (var m = 0; m<drones.length;m++){
                                            drones[m].follow = false
                                        }
                                        drones[index].follow = true
                                        map.center =drones[index].coordinate
                                    }
                                }
                            }
                            Button{
                                // U+20E0
                                //U+26C4
                                text: "Visible"
                                height: 20
                                width: 50
                                font.pixelSize: 11
                                highlighted: drones[index].visible
                                enabled: if(listItem.height === enlarged){true}else{false}

                                onClicked:{
                                    drones[index].visible = !drones[index].visible
                                }
                            }
                        }
                        Row{
                            spacing: 5
                            ComboBox{
                                id: cbColor
                                width: 80
                                height: 20
                                enabled: if(listItem.height === enlarged){true}else{false}
                                textRole: "text"
                                font.pixelSize: 10
                                property bool initial:false

                                model: ListModel{
                                    id: colorModel
                                }

                                Component.onCompleted: {
                                    for (var k = 0;k<colors.length;k++){
                                        colorModel.append(({"text": colors[k], "color": colors[k]}))
                                    }
                                    currentIndex = find(win.drones[index].droneColor)
                                    initial = true
                                }
                                onCurrentIndexChanged: {
                                    if (initial){
                                        droneModel.setProperty(index,"droneColor", colorModel.get(currentIndex).color)
                                        drones[index].droneColor = colorModel.get(currentIndex).color
                                        if (drones[index].pathPoly) line.line.color = colorModel.get(currentIndex).color

                                    }
                                }

                            }
                            Button{
                                //U+22B8
                                text: "Line"
                                height: 20
                                width: 40
                                font.pixelSize: 12
                                highlighted: drones[index].pathPoly
                                enabled: if(listItem.height === enlarged){true}else{false}
                                property int tmp
                                onClicked:{
                                    if (drones[index].pathPoly){
                                        drones[index].pathPoly = false
                                        line.clearPath()
                                    }else{
                                        for (var m = 0; m<drones.length;m++){
                                            drones[m].pathPoly = false
                                        }
                                        line.clearPath()
                                        drones[index].pathPoly = true
                                    }
                                }
                            }
                        }
                    }
                }
            }

            //Highlight on hover
            Component{
                id: mark
                Rectangle {
                    width: dronePanel.width
                    opacity: 0.5
                    color: "grey"
                    visible: (list.currentIndex  !== -1)
                }
            }

            ListView{
                id: list
                anchors.fill: parent
                model: droneModel
                delegate: listDelegate
                highlight: mark
                highlightFollowsCurrentItem: true
                highlightResizeVelocity: -1
                highlightMoveVelocity: -1

            }

            function addItem(droneID, droneColor){
                droneModel.append({"droneID": droneID, "lat": "-", "lon": "-", "speed": 0, "droneColor": droneColor})
            }

            function posChanged(index, newLat, newLon, speed){
                droneModel.setProperty(index,"lat",Algos.roundNumber(newLat,4).toString())
                droneModel.setProperty(index,"lon",Algos.roundNumber(newLon,4).toString())
                droneModel.setProperty(index,"speed",Math.round(speed))

            }


        }

        //Action PANEL

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

        Item {
            id: actionPanel
            width: 50


            anchors{
                right: parent.right
                bottom: map.bottom
                top: map.top
                rightMargin: 5
            }

            Rectangle{
                id: actionBG
                anchors.centerIn: parent
                width: parent.width
                height: 300
                opacity: 0.7
                color: "Grey"
                radius: 10
            }

            Column{
                anchors.fill: actionBG
                leftPadding: 5
                topPadding: actionBG.height/2-btnSize*4/2

                spacing: 20
                Button{
                    text: "X"
                    height: btnSize
                    width: btnSize
                    font.pixelSize: txtSize
                }
                RoundButton {
                    text: "X"
                    radius: btnSize / 2
                    font.pixelSize: txtSize
                }
                Button{
                    text: "X"
                    height: btnSize
                    width: btnSize
                    font.pixelSize: txtSize
                }

            }

        }

        Component.onCompleted: {
            Listener.start();
        }
    }
}

