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

    property variant usedColors: [] //NOT YET IMPLEMENTED
    property int txtSize: 14
    property int enlarged: 200
    property int small: txtSize + 15
    property int btnSize: 40
    property double zoomCircle
    property string zoomRadius

    function updateStaticPath(idInfo,colorInfo,posInfo){
        staticPath.visible = false
        staticPath.setPath(idInfo,colorInfo,posInfo)
        dynamicPath.line.color = colorInfo
    }

    function updateDynamicPath(idInfo,colorInfo,posInfo){
        if(dynamicPath.pathLength() <= 1000){
            dynamicPath.updatePath(posInfo)
        }else{
            dynamicPath.clearPath()
            updateStaticPath(idInfo,colorInfo,posInfo)
        }
    }

    function removeTrail(){
        staticPath.clearPath()
        dynamicPath.clearPath()
    }

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

        if (dist > 0) {
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

        info.push(dist)
        info.push(f)
        return info
    }

    function setCircleScale(){
        var info = calculateScale(100) //radius 50
        zoomCircle = (100 * info[1])/2 //border.width 3
        zoomRadius = Algos.formatDistance(info[0]/2)
    }

    function setZoomScale(){
        var info = calculateScale(scaleImage.sourceSize.width)
        scaleText.text = Algos.formatDistance(info[0])
        scaleImage.width = (scaleImage.sourceSize.width * info[1]) - 2 * scaleImageLeft.sourceSize.width
    }

    Map{
        id: map
        anchors.fill:parent
        plugin: Plugin{name:"mapboxgl"}
        center: QtPositioning.coordinate(54.3107,10.1291)
        zoomLevel: 14
        property bool rotating: false
        property bool centerFollowing: false

        onZoomLevelChanged:{
            win.setZoomScale()
            win.setCircleScale()
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
                win.setZoomScale();
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
                text: "Zoom: " + Math.round(map.zoomLevel)
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
            property int nn
            property double nnBear

            onPositionChanged: {
                cor = map.toCoordinate(Qt.point(mouse.x, mouse.y))
                coorLbl.text = Algos.roundNumber(cor.latitude,3) + ", " +  Algos.roundNumber(cor.longitude,3)

                //rotation
                //scale win.height - nn = 360
                if (map.rotating){

                    map.bearing = nnBear + (nn - mouseY) * (360/win.height)
                }
            }

            onEntered: dronePanel.noMark()

            onClicked: {
                if (mouse.button === Qt.LeftButton && !map.centerFollowing){
                    map.rotating = !map.rotating
                    nn = mouseY
                    nnBear = map.bearing
                    if (!map.rotating) map.droneRotAniLock = false
                }
            }

            onPressAndHold:{
                map.rotating = false
                map.bearing = 0
            }
        }

        PolyLine {id: staticPath}
        PolyLine{id: dynamicPath}

        property bool droneRotAniLock: false
        property double lastMapBearing

        onBearingChanged: {
            if(lastMapBearing){
                if (Math.abs(lastMapBearing - map.bearing) > 0.1){
                    droneRotAniLock = true
                }else{
                    droneRotAniLock = false
                }
            }

            lastMapBearing = map.bearing
        }

        Behavior on bearing{
            enabled: !map.rotating
            RotationAnimation{
                id: rotAni
                duration: 100
                direction: RotationAnimation.Shortest
                easing.type: Easing.Linear
                onRunningChanged: {
                    if (!rotAni.running) { //stop
                        map.droneRotAniLock = false
                    } else { //start

                    }
                }
            }
        }

        MapItemView{
            model: dronemodel

            delegate:MapItemGroup{

                Drone{
                    id: droneBody
                    droneColor: colorInfo
                    extrapolating: extrapolateInfo

                    extrapolationTime: 1000

                    onExtrapolatingChanged: {
                        if (extrapolating){
                            //extrapolationTime/1000*speed
                            extrapolatingAnimation = true
                            var dist = extrapolationTime/1000*100
                            coordinate = posInfo.atDistanceAndAzimuth(dist,angleInfo)
                        }else{
                            extrapolatingAnimation = false
                            coordinate = posInfo
                        }
                    }

                    onCoordinateChanged: {

                        if (trackingHistoryInfo) updateDynamicPath(idInfo,colorInfo,posInfo)
                        if (followInfo){
                            map.center = coordinate
                            map.bearing = angleInfo
                            bearing = 0
                        }else{
                            bearing= angleInfo - map.bearing
                        }

                        //update Panel info
                        //ADD -> save index of Key & add field in DronePanel
                        //
                    }
                }

                MapQuickItem{
                    id:circleRuler
                    coordinate: droneBody.coordinate
                    anchorPoint.x: zoomCircle
                    anchorPoint.y: zoomCircle


                    sourceItem: Item{
                        width: zoomCircle * 2
                        height: zoomCircle * 2

                        Rectangle{
                            anchors.fill: parent
                            radius: zoomCircle
                            border.color: colorInfo
                            border.width: 1
                            color: '#00000000'
                        }

                        Text {
                            anchors.horizontalCenter: parent.horizontalCenter
                            anchors.bottom: parent.top
                            text: zoomRadius
                            font.bold: true
                        }
                    }
                    Component.onCompleted: win.setCircleScale()
                }

            }
        }
    }


    DronePanel{id:dronePanel}
    ActionPanel{id:actionPanel}

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

