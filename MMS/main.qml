import QtQuick 2.13
import QtQuick.Controls 2.5
import QtQuick.Window 2.13
import QtQuick.Layouts 1.13
import QtPositioning 5.13
import QtLocation 5.13
import QtQuick.Particles 2.13
import "algos.js" as Algos
import Controller 1.0

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
    property int zoomOffset: 0
    property variant droneCorList
    property int movingWpIndex:-1
    property double tmpCircleRadius
    property variant tmpRectCor
    property variant mousePos:QtPositioning.coordinate(0,0)


    //MAP SCALE
    property variant scaleLengths: [5, 10, 20, 50, 100, 200, 500, 1000, 2000, 5000, 10000, 20000, 50000, 100000, 200000, 500000, 1000000, 2000000]
    function calculateScale(objWidth,direction)
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

                    if(i+direction>= scaleLengths.length-1){
                        direction = scaleLengths.length-1-i
                        zoomOffset = direction
                    }else if(i+direction < 0){
                        direction = -i
                        zoomOffset = direction
                    }

                    f = scaleLengths[i+direction] / dist
                    dist = scaleLengths[i+direction]
                    break;
                }
            }
            if (f === 0) {
                f = dist / scaleLengths[i+direction]
                dist = scaleLengths[i+direction]
            }
        }

        info.push(dist)
        info.push(f)
        return info
    }


    function setCircleScale(k){
        var info = calculateScale(50,k)
        zoomRadius = Algos.formatDistance(info[0])
        zoomCircle = (50*info[1])
    }

    function setZoomScale(){
        var info = calculateScale(50,0)
        scaleText.text = Algos.formatDistance(info[0])
        scaleImage.width = (50*info[1]) - 2 * scaleImageRight.width
    }

    function centerMapRegion(markers){
        var region

        if(markers.length === 1){
            region = QtPositioning.circle(markers[0],200)
        }else if(markers.length === 2){
            var radius = markers[0].distanceTo(markers[1])/2
            var circleCenter = Algos.getLatLngCenter(markers)
            region = QtPositioning.circle(QtPositioning.coordinate(circleCenter[0],circleCenter[1]),radius)
        }else if(markers.length > 2){
            region = QtPositioning.polygon(markers)
        }
        return region
    }

    Map{
        id: map
        anchors.fill:parent
        z:1
        plugin: Plugin{
            name:"mapboxgl"
            PluginParameter{name:"mapboxgl.access_token";value:"pk.eyJ1IjoidGltb3RoeWx1ZWQiLCJhIjoiY2swNTd4N3pyMDQ1djNjcWk3YWk1Mmw4aiJ9.peN9sLC_oLX5m-KOT5RTlA"}
            PluginParameter{name:"mapboxgl.mapping.additional_style_urls"; value:"mapbox://styles/timothylued/ck06pdqf709ea1do535fgthp6,mapbox://styles/timothylued/ck05as97w08w21dp9ak2ukiru"} //outdoors,darkmode
        }
        activeMapType: supportedMapTypes[0]

        center: QtPositioning.coordinate(54.3107,10.1291)
        zoomLevel: 14

        property bool droneRotAniLock: false
        property double lastMapBearing

        property bool rotating: false
        property bool centerFollowing: false
        property bool isCenterOnAll: false
        property string groupfollow: ""
        property bool circleRulerVisible: false

        onZoomLevelChanged:{
            win.setZoomScale()
            win.setCircleScale(zoomOffset)
            zoomLbl.text = "Zoom: " + Math.round(map.zoomLevel)
        }

        Behavior on zoomLevel{
            enabled: !map.isCenterOnAll&&!map.groupfollow
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
            property int nn
            property double nnBear

            onPositionChanged: {
                mousePos = map.toCoordinate(Qt.point(mouse.x, mouse.y))

                if (movingWpIndex!=-1){
                    onMapWpModel.set(movingWpIndex,{"name":onMapWpModel.get(movingWpIndex).name,"lat":mousePos.latitude,"lon":mousePos.longitude})
                    routeEditPoly.update()
                    wpModel.set(movingWpIndex,{"name":wpModel.get(movingWpIndex).name,"lat":mousePos.latitude,"lon":mousePos.longitude})
                }

                if(missionPanel.addingTaskCor){
                    if(missionPanel.selectedTaskType=="circle"&& corModel.count==1){
                        tmpCircleRadius = QtPositioning.coordinate(corModel.get(0).cor.latitude,corModel.get(0).cor.longitude).distanceTo(mousePos)
                        radiusPoly.update(mousePos)
                    }else if(missionPanel.selectedTaskType=="rectangle"&& corModel.count==1){
                        if(rectModel.get(0).cor1.latitude>mousePos.latitude&&rectModel.get(0).cor1.longitude<mousePos.longitude)
                            tmpRectCor = mousePos
                    }
                }

                if(wpPanel.addingWaypoints||missionPanel.addingTaskCor){
                    cursorShape = Qt.CrossCursor
                }else{
                    cursorShape = Qt.ArrowCursor
                }

                coorLbl.text = Algos.roundNumber(mousePos.latitude,3) + ", " +  Algos.roundNumber(mousePos.longitude,3)
                //rotation
                //scale win.height - nn = 360
                if (map.rotating)map.bearing = nnBear + (nn - mouseY) * (360/win.height)

            }

            onClicked: {
                if (mouse.button === Qt.MiddleButton && !map.centerFollowing){
                    map.rotating = !map.rotating
                    nn = mouseY
                    nnBear = map.bearing
                    if (!map.rotating) map.droneRotAniLock = false
                }else if(mouse.button === Qt.LeftButton && wpPanel.addingWaypoints){
                    wpModel.append({"name":"","lat":mousePos.latitude,"lon":mousePos.longitude})
                    onMapWpModel.update()
                }else if(mouse.button === Qt.LeftButton &&missionPanel.addingTaskCor){
                    missionPanel.addMouseCor(mousePos)
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
            visible: scaleText.text != "0 m"
            anchors{
                bottom: parent.bottom;
                right: parent.right
                margins: 10
            }

            height: scaleText.height * 2
            width: scaleImage.width

            Rectangle {
                id: scaleImageLeft
                height:5
                width:2
                color:infobar.mColor
                anchors.verticalCenter: scaleImage.verticalCenter
                anchors.right: scaleImage.left
            }
            Rectangle {
                id: scaleImage
                height:2
                color:infobar.mColor
                anchors.bottom: parent.bottom
                anchors.right: scaleImageRight.left
            }
            Rectangle {
                id: scaleImageRight
                height:5
                width:2
                color:infobar.mColor
                anchors.verticalCenter: scaleImage.verticalCenter
                anchors.right: parent.right
            }

            Text{
                id: scaleText
                color: infobar.mColor
                anchors.centerIn: parent
                text: "0 m"
                font.pixelSize: 16
            }
            Component.onCompleted: {
                win.setZoomScale();
            }
        }

        Item{
            id: infobar
            property string mColor:map.activeMapType ===  map.supportedMapTypes[1]?"white":"#004EAE"
            anchors{
                top: parent.top
                right: parent.right
                margins: 10
            }
            height: zoomLbl.height * 2
            width: 110

            //Zoom Label
            Text {
                id: zoomLbl
                color: parent.mColor
                horizontalAlignment: Text.AlignRight
                width: coorLbl.width
                anchors.right: parent.right
                text: "Zoom: " + Math.round(map.zoomLevel)
                font.pixelSize: 16
            }

            Text {
                id: coorLbl
                color: parent.mColor
                anchors.top:zoomLbl.bottom
                anchors.left: parent.left
                font.pixelSize: 16
            }
        }

        Item {
            width:compass.implicitWidth
            height:compass.implicitHeight

            anchors{
                margins: 10
                right: infobar.left
                verticalCenter: infobar.verticalCenter
            }

            Text{
                id: compass
                text: "\u29BD"
                font.pixelSize: 35
                color: infobar.mColor
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                anchors.fill: parent
            }

            transform: Rotation {
                origin.x: compass.implicitWidth/2
                origin.y: compass.implicitHeight/2+2
                angle: 360 - map.bearing
            }
        }

        MapItemView{
            id: droneObjects
            model: dronemodel

            delegate:MapItemGroup{

                Drone{
                    id: droneBody
                    z:200
                    droneColor: groupInfo!=""? groupInfo:colorInfo
                    extrapolating: extrapolateInfo
                    droneId: idInfo
                    bearing: followInfo?0:angleInfo - map.bearing
                    extrapolationTime: 1000
                    visible: visibleInfo
                    trackingHistory: trackingHistoryInfo
                    property int historyStart: rangeInfo[0]
                    property int historyEnd: rangeInfo[1]

                    onHistoryStartChanged: updateHistory()
                    onHistoryEndChanged: updateHistory()

                    function updateHistory(){
                        if(trackingHistory){
                            dynamicPath.path = []
                            mWorker.sendMessage({'hist':historyInfo})
                        }
                    }

                    property string note:noteInfo
                    onNoteChanged: notifyPanel.show(note.substring(2))

                    property double dist
                    onExtrapolatingChanged: {
                        if (extrapolating){
                            extrapolatingAnimation = true
                            dist = speedInfo? extrapolationTime/1000*speedInfo : 0 //seconds * m/s
                            coordinate = posInfo.atDistanceAndAzimuth(dist,angleInfo)
                        }else{
                            extrapolatingAnimation = false
                            coordinate = posInfo

                        }

                    }

                    onTrackingHistoryChanged: {
                        dynamicPath.path = []
                        staticPath.path = []
                        if (trackingHistory){
                            if(historyEnd===-2) {
                                dynamicPath.addCoordinate(posInfo)
                                dynamicPath.buffer.push(coordinate)
                            }
                            k = 0
                            if (historyInfo.length > 1) {
                                threadRunning = true
                                mWorker.sendMessage({'hist':historyInfo})
                            }
                        }
                    }
                    property int k: 50
                    property bool threadRunning: false

                    onCoordinateChanged: {
                        var n,first, second
                        if (trackingHistory&&historyEnd===-2) {
                            n = dynamicPath.pathLength()

                            if (k >= 50){//every 50th or corner
                                if(n <= 100||threadRunning){
                                    if (threadRunning) dynamicPath.buffer.push(coordinate)
                                    dynamicPath.addCoordinate(posInfo)
                                    k = 0
                                }else{
                                    threadRunning = true
                                    mWorker.sendMessage({'hist':historyInfo})
                                }


                            }else if(n>1){
                                first = dynamicPath.path[n-2].azimuthTo(dynamicPath.path[n-1])
                                second = dynamicPath.path[n-1].azimuthTo(posInfo)
                                if (Math.abs(first-second)>1 && first!==0 && second!==0){
                                    dynamicPath.addCoordinate(posInfo)
                                    k=0
                                }else{
                                    k+=1
                                }
                            }else{
                                k+=1
                            }
                        }

                        var region
                        var positions = []
                        if (map.isCenterOnAll) {
                            if (followInfo) dronemodel.toggleFollow(idInfo)
                            positions = dronemodel.getAllDronePos()
                            if (positions.length>0){
                                region = centerMapRegion(positions)
                                map.fitViewportToGeoShape(region,200)
                            }

                        }else if(map.groupfollow!=""){
                            if (followInfo) dronemodel.toggleFollow(idInfo)
                            var groupMembers = groupmodel.getMembers(map.groupfollow)
                            for(var i=0;i<groupMembers.length;i++){
                                var dronePos = dronemodel.getDronePos(groupMembers[i])
                                if(dronePos.isValid) positions.push(dronePos)
                            }
                            if (positions.length>0){
                                region = centerMapRegion(positions)
                                map.fitViewportToGeoShape(region,200)
                            }
                        }

                        if (followInfo){
                            map.center = coordinate
                            map.pan(0,-map.height/2+100)
                            map.bearing = angleInfo
                            map.centerFollowing = true
                            map.rotating = false

                        }else map.centerFollowing = false

                        //update hotleg pointer
                        wpPointer.direction = hotLegPoly.pathLength()>0? coordinate.azimuthTo(hotLegPoly.path[1]):0
                        wpPointer.visible = hotLegPoly.pathLength()>0
                    }

                    WorkerScript{
                        id:mWorker
                        source: "simplifyPoly.js"
                        onMessage: {
                            staticPath.update(messageObject.simple)
                        }
                    }
                }


                MapQuickItem{
                    id:circleRuler
                    z:100
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
                            border.color: droneBody.droneColor
                            border.width: 1
                            color:  "transparent"
                        }

                        Text {
                            text: zoomRadius
                            color: map.activeMapType ===  map.supportedMapTypes[1]?"white":"black"
                            font.bold: true
                            anchors.horizontalCenter: parent.horizontalCenter
                            anchors.bottom: parent.top
                            renderType: Text.NativeRendering
                        }
                    }
                    Component.onCompleted: win.setCircleScale(zoomOffset)
                }

                MapQuickItem{
                    id:wpPointer
                    visible: visibleInfo
                    coordinate: droneBody.coordinate
                    anchorPoint.y: 10
                    anchorPoint.x: 10
                    property double direction:0


                    sourceItem: Item{
                        width:20
                        height:20
                        y: -20

                        transform: Rotation{
                            origin.x: 10
                            origin.y: 30
                            angle: wpPointer.direction - map.bearing
                        }

                        Rectangle{
                            anchors.fill:parent
                            color:"transparent"
                            Text{
                                id:arrowText
                                width:parent.width
                                height:parent.height
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                                y:-1
                                text: "\u25B2"
                                font.pixelSize: 12
                                anchors.horizontalCenter: parent.horizontalCenter

                            }
                        }


                    }

                }

                MapQuickItem {//PopUp
                    visible: droneBody.popUp && visibleInfo
                    coordinate: droneBody.coordinate
                    z: 200
                    anchorPoint.x: if (!followInfo) {-10}else{-droneBody.width / 2}
                    anchorPoint.y: if (!followInfo) {-10}else{popItem.height / 2}

                    sourceItem: Item{
                        id:popItem
                        width: 100
                        height: 100

                        Rectangle{anchors.fill: parent; color: "white"; opacity: 1}


                        Rectangle{
                            anchors.fill: parent
                            anchors.margins: 2

                            Text{
                                id: popHeader
                                text: idInfo
                                anchors{
                                    left: parent.left
                                    top: parent.top

                                }
                                font.bold: true
                                font.pixelSize: txtSize
                                color: droneBody.droneColor
                                renderType: Text.NativeRendering
                            }

                            Rectangle{
                                anchors{
                                    right: parent.right
                                    top: parent.rop
                                }

                                width: 17
                                height: 17
                                border.color: closeBtnText.color
                                border.width: 1
                                color: "transparent"
                                Text {
                                    id:closeBtnText
                                    text: "X"
                                    anchors.fill:parent
                                    font.pixelSize: 12
                                    horizontalAlignment: Text.AlignHCenter
                                    verticalAlignment: Text.AlignVCenter
                                    color: "black"
                                    elide: Text.ElideRight
                                }
                                MouseArea{
                                    anchors.fill:parent
                                    onClicked: {
                                        droneBody.popUp = false
                                    }
                                }
                            }

                            Flickable {
                                id: fparent
                                anchors{
                                    bottom: parent.bottom
                                    top: popHeader.bottom
                                    left:parent.left
                                }
                                width: parent.width
                                interactive: true
                                clip: true
                                flickableDirection: Flickable.VerticalFlick
                                contentHeight: dataLV.height

                                ListView{
                                    id: dataLV
                                    anchors{
                                        left: parent.left
                                        right: parent.right
                                    }

                                    height: childrenRect.height
                                    clip: true
                                    interactive: false
                                    model: infoSelectedNamesInfo
                                    property variant columnWidths: Algos.calcColumnWidths(model, dataLV)

                                    delegate: Component{
                                        Item{
                                            id: body
                                            width: parent.width
                                            height: row.height


                                            Row{
                                                id: row
                                                width: parent.width
                                                spacing: 2

                                                Text{
                                                    id: keyText
                                                    text: infoSelectedNamesInfo[index]
                                                    wrapMode: Text.WrapAnywhere
                                                    width: dataLV.columnWidths
                                                    renderType: Text.NativeRendering
                                                }
                                                Loader { sourceComponent: columnSeparator; height:keyText.height>valueText.height?keyText.height:valueText.height }
                                                Text{
                                                    id: valueText
                                                    text: infoSelectedValuesInfo[index]
                                                    color: valueText.text.includes("\u2227")?"green":(text.includes("\u2228")?"red":"black")
                                                    wrapMode: Text.WrapAnywhere
                                                    width: parent.width - dataLV.columnWidths-row.spacing*2
                                                    renderType: Text.NativeRendering
                                                }
                                                Component {
                                                    id: columnSeparator
                                                    Rectangle {
                                                        width: 1
                                                        color: "black"
                                                        opacity: 0.3
                                                    }
                                                }
                                            }
                                        }
                                    }

                                    onCountChanged: {
                                        fparent.returnToBounds();
                                    }
                                }
                            }
                        }
                    }
                }


                MapPolyline{//Static
                    id: staticPath
                    visible: trackingHistoryInfo&& visibleInfo
                    line.color: droneBody.droneColor
                    line.width: 1

                    function update(path){
                        var shortPath = []

                        for (var i = 0; i<path.length;i++){
                            if(path[i]){
                                shortPath.push(QtPositioning.coordinate(path[i][0],path[i][1]))
                            }
                        }

                        if(shortPath.length>0){
                            staticPath.path = shortPath
                            dynamicPath.update()
                            droneBody.k = 50
                            droneBody.threadRunning = false
                        }
                    }
                }

                MapPolyline{//dynamic
                    id: dynamicPath
                    property variant buffer:[] //updates during staticPath is calculating poly
                    function update(){
                        path = []
                        buffer.push(staticPath.path[staticPath.pathLength()-1])
                        path = buffer
                        buffer = []
                    }
                    visible: trackingHistoryInfo&& visibleInfo
                    line.color: droneBody.droneColor
                    line.width: 1
                }

                MapPolyline{
                    id: routePoly
                    visible: showingRouteInfo&& visibleInfo
                    path: routeInfo
                    line.color: droneBody.droneColor
                    line.width: 1
                }

                MapPolyline{
                    id: hotLegPoly
                    visible: showingRouteInfo&& visibleInfo
                    path: legInfo
                    line.color: droneBody.droneColor
                    line.width: 3
                }

            }

        }

        //models for displaying whole tasks
        ListModel{id:pathModel}
        ListModel{id:markerModel}
        ListModel{id:circleModel}//{cor1,cor2}
        ListModel{id:rectModel}//{cor1,cor2}
        ListModel{id:polyModel}//{polyPath:[cor,cor]

        ListModel{id:corModel}

        MapItemView{
            id: pathType
            model: pathModel

            delegate: MapPolyline {
                line.color: "black"
                line.width: 2
                Component.onCompleted: {
                    var corList = []
                    for (var i=0;i<pPath.count;i++){
                        corList.push(QtPositioning.coordinate(pPath.get(i).lat,pPath.get(i).lon))
                    }
                    path=corList
                }
            }
        }

        MapItemView{
            id: polyType
            model:polyModel

            delegate: MapPolygon {
                color: "blue"
                opacity: 0.3
                border.width: 2
                border.color:"black"

                Component.onCompleted: {
                    var corList = []
                    for (var i=0;i<pPath.count;i++){
                        corList.push(QtPositioning.coordinate(pPath.get(i).lat,pPath.get(i).lon))
                    }
                    path=corList
                }
            }
        }

        MapItemView {
            id: taskMarker
            model:markerModel

            delegate: MapQuickItem {
                coordinate: QtPositioning.coordinate(cor.latitude,cor.longitude)
                anchorPoint.x: 10
                anchorPoint.y: 10

                sourceItem:Rectangle{
                    color: "#3EC6AA"
                    width: 20
                    height: 20
                    radius: width/2
                    Text {
                        text: index!=-1? (index + 1) : ""
                        color: "white"
                        anchors.centerIn: parent
                        font.bold: true
                    }

                    MouseArea{
                        anchors.fill:parent
                        onClicked: {
                            if (mouse.button === Qt.LeftButton && missionPanel.addingTaskCor)
                                missionPanel.addMouseCor(coordinate)

                        }
                    }

                }

            }
        }

        MapItemView{
            id: circleType
            model:circleModel

            delegate: MapCircle {
                id:circle
                center:QtPositioning.coordinate(cor.latitude,cor.longitude)
                radius:(missionPanel.addingTaskCor||!rad)?win.tmpCircleRadius:rad
                color: "#eb8328"
                opacity: 0.3
                border.width: 3
                border.color: "black"
                onCenterChanged: radiusPoly.setStart(center)
                onRadiusChanged: if(missionPanel.addingTaskCor&&missionPanel.selectedTaskType=="circle"){
                                     distText.updateText(Algos.roundNumber(radius,0))
                                     missionPanel.showRadius(radius)
                                 }
            }

        }

        MapQuickItem{
            coordinate: win.mousePos
            sourceItem: Text{
                id:distText
                function updateText(r){
                    text = r + " m"
                    visible = r!==""
                }
            }
            anchorPoint.x:-sourceItem.width
            anchorPoint.y:sourceItem.height
        }

        MapPolyline{
            id:radiusPoly
            function setStart(cor){
                path = []
                addCoordinate(QtPositioning.coordinate(cor.latitude,cor.longitude))
                addCoordinate(QtPositioning.coordinate(cor.latitude,cor.longitude))
            }
            function update(cor){
                replaceCoordinate(1,cor)
            }
        }


        MapItemView{
            id: rectType
            model:rectModel
            delegate: MapRectangle {
                color: "#38d93e"
                border.width: 2
                border.color: "black"
                opacity: 0.3
                topLeft:QtPositioning.coordinate(cor1.latitude,cor1.longitude)
                bottomRight:(!cor2||missionPanel.addingTaskCor)?win.tmpRectCor:QtPositioning.coordinate(cor2.latitude,cor2.longitude)
            }
        }

        //Waypoints
        MapPolyline{
            id: routeEditPoly
            line.color: "black"
            line.width: 1

            function update(){
                var mPath = []
                for (var i = 0; i<onMapWpModel.count;i++){
                    mPath.push(QtPositioning.coordinate(onMapWpModel.get(i).lat,onMapWpModel.get(i).lon))
                }
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
                    color: "#3EC6AA"
                    width: 20
                    height: 20
                    radius: width/2
                    Text {
                        text: index!=-1? (index + 1) : ""
                        color: "white"
                        anchors.centerIn: parent
                        font.bold: true
                    }

                    MouseArea{
                        anchors.fill:parent
                        onClicked: {
                            if (mouse.button === Qt.LeftButton) {
                                if(wpPanel.addingWaypoints){
                                    //same coordinate again --> for circle course

                                    wpModel.append({"name":"","lat":coordinate.latitude,"lon":coordinate.longitude})
                                    onMapWpModel.update()

                                }else{
                                    if (movingWpIndex!=-1){
                                        for (var i=0;i<wpModel.count;i++){
                                            if(i!==movingWpIndex){
                                                if(coordinate.distanceTo(QtPositioning.coordinate(wpModel.get(i).lat,wpModel.get(i).lon)) < 30){
                                                    onMapWpModel.set(movingWpIndex,{"name":onMapWpModel.get(movingWpIndex).name,"lat":wpModel.get(i).lat,"lon":wpModel.get(i).lon})
                                                    routeEditPoly.update()
                                                    wpModel.set(movingWpIndex,{"name":wpModel.get(movingWpIndex).name,"lat":wpModel.get(i).lat,"lon":wpModel.get(i).lon})
                                                    break
                                                }
                                            }
                                        }
                                    }
                                    movingWpIndex=movingWpIndex==-1?index:-1

                                }
                            }
                        }
                    }

                }

            }
        }



    }
    Map {
        id: mapOverlay
        anchors.fill: parent
        plugin: Plugin { name: "itemsoverlay" }
        gesture.enabled: false
        center: map.center
        color: 'transparent'
        minimumFieldOfView: map.minimumFieldOfView
        maximumFieldOfView: map.maximumFieldOfView
        minimumTilt: map.minimumTilt
        maximumTilt: map.maximumTilt
        minimumZoomLevel: map.minimumZoomLevel
        maximumZoomLevel: map.maximumZoomLevel
        zoomLevel: map.zoomLevel
        tilt: map.tilt;
        bearing: map.bearing
        fieldOfView: map.fieldOfView
        z: map.z + 1


        ListModel {//in order to change order without violatioing active model
            id: wpModel
        }

        ListModel {
            id: onMapWpModel
            function update(){
                onMapWpModel.clear()
                for (var i = 0; i<wpModel.count;i++){
                    //onMapWpModel.append(wpModel.get(i))
                    onMapWpModel.append({"name":wpModel.get(i).name,"lat":wpModel.get(i).lat,"lon":wpModel.get(i).lon})
                }
                routeEditPoly.update()
            }
        }

        DronePanel{id:dronePanel}
        ActionPanel{id:actionPanel}
        NotificationPanel{id:notifyPanel}
        WaypointPanel{id: wpPanel}
        MissionPanel{id: missionPanel;z:100}
    }

    Controller{
        id: controller

    }

}


