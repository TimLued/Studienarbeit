import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Window 2.12
import QtQuick.Layouts 1.12
import QtPositioning 5.13
import QtLocation 5.13
import "algos.js" as Algos

ApplicationWindow  {
    id: win
    visible: true
    title: "MMS GUI"
    width: 800
    height: 500

    property int txtSize: 14
    property int enlarged: 200
    property int small: txtSize + 15
    property int btnSize: 40
    property double zoomCircle
    property string zoomRadius

    property variant droneCorList


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
        var info = calculateScale(scaleImage.sourceSize.width)
        zoomRadius = Algos.formatDistance(info[0])
        zoomCircle = (scaleImage.sourceSize.width * info[1]) //border.width 3
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

        property bool droneRotAniLock: false
        property double lastMapBearing

        property bool rotating: false
        property bool centerFollowing: false
        property bool isCenterOnAll: false
        property bool circleRulerVisible: false
        
        property bool setWaypoints: false

        onZoomLevelChanged:{
            win.setZoomScale()
            win.setCircleScale()
            zoomLbl.text = "Zoom: " + Math.round(map.zoomLevel)
        }

        Behavior on zoomLevel{
            NumberAnimation{
                duration: 100
            }
        }

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
                duration: 100
                direction: RotationAnimation.Shortest
                easing.type: Easing.Linear
                onRunningChanged: {
                    if (!running) { //stop
                        map.droneRotAniLock = false
                    } else { //start
                    }
                }
            }
        }

        MouseArea{
            anchors.fill: parent
            hoverEnabled: true
            acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton
            property variant cor
            property int nn
            property double nnBear

            onPositionChanged: {
                cor = map.toCoordinate(Qt.point(mouse.x, mouse.y))

                coorLbl.text = Algos.roundNumber(cor.latitude,3) + ", " +  Algos.roundNumber(cor.longitude,3)

                //rotation
                //scale win.height - nn = 360
                if (map.rotating)map.bearing = nnBear + (nn - mouseY) * (360/win.height)

            }

            onEntered: dronePanel.noMark()

            onClicked: {
                if (mouse.button === Qt.MiddleButton && !map.centerFollowing){
                    map.rotating = !map.rotating
                    nn = mouseY
                    nnBear = map.bearing
                    if (!map.rotating) map.droneRotAniLock = false

                }else if(mouse.button === Qt.LeftButton && map.setWaypoints){
                    var cor = map.toCoordinate(Qt.point(mouse.x, mouse.y))
                    wpModel.append({"name":"","lat":cor.latitude.toString(),"lon":cor.longitude.toString()})
                    //onMapWpModel.append({"name":"","lat":cor.latitude.toString(),"lon":cor.longitude.toString()})
                    onMapWpModel.update()
                }
            }

            onPressAndHold:{
                if (mouse.button === Qt.MiddleButton){
                    map.rotating = false
                    map.bearing = 0
                }else if(mouse.button === Qt.LeftButton){
                }
            }
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
                anchors.top:zoomLbl.bottom
                anchors.left: parent.left
            }
        }

        MapItemView{
            id: droneObjects
            model: dronemodel

            delegate:MapItemGroup{

                Drone{
                    id: droneBody
                    droneColor: colorInfo
                    extrapolating: extrapolateInfo
                    droneId: idInfo
                    extrapolationTime: 1000
                    visible: visibleInfo
                    trackingHistory: trackingHistoryInfo

                    onExtrapolatingChanged: {
                        if (extrapolating){
                            extrapolatingAnimation = true
                            var dist = extrapolationTime/1000*speedInfo
                            coordinate = posInfo.atDistanceAndAzimuth(dist,angleInfo)
                        }else{
                            extrapolatingAnimation = false
                            coordinate = posInfo
                        }

                    }

                    onTrackingHistoryChanged: {
                        if (!trackingHistory){
                            dynamicPath.path = []
                            staticPath.path = []
                        }else{
                            if (historyInfo.length > 1) staticPath.mPath = historyInfo
                            k = 50
                        }
                    }

                    property int k: 50
                    property variant region

                    onCoordinateChanged: {
                        if (trackingHistory) {

                            if (k == 50){
                                if(dynamicPath.pathLength() <= 100){
                                    dynamicPath.addCoordinate(posInfo)

                                }else{
                                    dynamicPath.path = []
                                    staticPath.mPath = historyInfo
                                }

                                k = 0
                            }else{
                                k+=1
                            }
                        }

                        if (followInfo){
                            map.center = coordinate
                            map.pan(0,-map.height/2+100)
                            bearing = 0
                            map.bearing = angleInfo
                            map.centerFollowing = true
                            map.rotating = false
                        }else{
                            bearing= angleInfo - map.bearing
                            map.centerFollowing = false
                        }

                        if (map.isCenterOnAll) {


                            if (followInfo) dronemodel.toggleFollow(idInfo)

                            var drones = dronemodel.getAllDronePos()

                            if(drones.length === 1){
                                region = QtPositioning.circle(drones[0],500)
                            }else if(drones.length === 2){
                                var radius = drones[0].distanceTo(drones[1])/2
                                var circleCenter = Algos.getLatLngCenter(drones)
                                region = QtPositioning.circle(QtPositioning.coordinate(circleCenter[0],circleCenter[1]),radius)
                            }else if(drones.length > 2){
                                region = QtPositioning.polygon(drones)
                            }

                            map.fitViewportToGeoShape(region,80)
                        }
                    }
                }


                MapQuickItem{
                    id:circleRuler
                    visible: map.circleRulerVisible && visibleInfo
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
                            renderType: Text.NativeRendering
                        }
                    }
                    Component.onCompleted: win.setCircleScale()
                }

                MapQuickItem {//PopUp
                    visible: droneBody.popUp
                    coordinate: droneBody.coordinate

                    anchorPoint.x: if (!followInfo) {-10}else{-droneBody.width / 2}
                    anchorPoint.y: if (!followInfo) {-10}else{popItem.height / 2}

                    sourceItem: Item{
                        id:popItem
                        width: 100
                        height: 100

                        Rectangle{anchors.fill: parent; color: "white"; opacity: 0.8}
                        Column{
                            anchors.fill: parent
                            anchors.margins: 5
                            anchors.bottomMargin: 0
                            spacing: 4
                            layer.enabled: true

                            RowLayout {
                                width: parent.width
                                Rectangle{
                                    color: "transparent"
                                    height: childrenRect.height
                                    width: childrenRect.width
                                    Layout.alignment: Qt.AlignLeft
                                    Text{text: idInfo
                                        font.bold: true
                                        font.pixelSize: txtSize
                                        color: colorInfo
                                        renderType: Text.NativeRendering
                                    }
                                }
                                Rectangle{
                                    color: "transparent"
                                    height: childrenRect.height
                                    width: childrenRect.width
                                    Layout.alignment: Qt.AlignRight
                                    Button{
                                        width: 20
                                        height:20
                                        text: "X"
                                        onClicked: droneBody.popUp = !droneBody.popUp
                                    }
                                }


                            }

                            Flickable {
                                id: fparent
                                height:70
                                width: parent.width

                                interactive: true
                                clip: true
                                flickableDirection: Flickable.VerticalFlick
                                contentHeight: dataLV.height


                                ListView{
                                    id: dataLV
                                    width: fparent.width
                                    height: childrenRect.height
                                    clip: true
                                    interactive: false
                                    spacing: 2
                                    model: infoInfo

                                    delegate: Text{
                                        text: dataLV.model[index].name + ": " + dataLV.model[index].value
                                        wrapMode: Text.WrapAnywhere
                                        width: dataLV.width
                                    }

                                    onCountChanged: {
                                        fparent.returnToBounds();
                                    }
                                }
                            }
                        }
                    }
                }

                HistoryPoly{//Static
                    id: staticPath
                    visible: trackingHistoryInfo && visibleInfo
                    line.color: colorInfo


                }

                MapPolyline{//dynamic
                    id: dynamicPath
                    visible: trackingHistoryInfo && visibleInfo
                    line.color: colorInfo
                    line.width: 1
                }

            }
        }

        MapPolyline{
            id: routePoly
            line.color: "red"
            line.width: 1

            property variant lats: [] //because model as strings -> path conversion
            property variant lons: []
            onLatsChanged: {
                var mPath = []
                for (var i = 0;i<lats.length;i++){
                    mPath.push(QtPositioning.coordinate(lats[i],lons[i]))
                }
                //mPath.push(QtPositioning.coordinate(lats[0],lons[0]))
                path = mPath
            }
        }

        MapItemView {
            id: wpMarker
            model: onMapWpModel

            delegate: MapQuickItem {
                coordinate: QtPositioning.coordinate(lat,lon)

                anchorPoint.x: 10
                anchorPoint.y: 10

                sourceItem:Rectangle{
                    color: "#FF2F44"
                    width: 20
                    height: 20
                    radius: width/2
                    Text {
                        text: index!=-1? (index + 1) : ""
                        color: "white"
                        anchors.centerIn: parent
                        font.bold: true
                    }
                }
            }
        }

        WaypointPanel{
            id: wpPanel

            anchors{
                right: actionPanel.left
                rightMargin: 5
                verticalCenter: map.verticalCenter
            }
        }

        ListModel {//in order to change order without violatioing active model
            id: wpModel
        }

        ListModel {
            id: onMapWpModel
            function update(){
                onMapWpModel.clear()
                var lats = []
                var lons = []
                for (var i = 0; i<wpModel.count;i++){
                    onMapWpModel.append(wpModel.get(i))
                    lats.push(wpModel.get(i).lat)
                    lons.push(wpModel.get(i).lon)
                }
                routePoly.lons = lons
                routePoly.lats = lats
            }
        }

        DronePanel{id:dronePanel}
        ActionPanel{id:actionPanel}

    }

}

