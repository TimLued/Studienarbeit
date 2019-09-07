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
    property int zoomOffset: 0
    property variant droneCorList

    property int movingMarker:-1


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
        var info = calculateScale(scaleImage.sourceSize.width,k)
        zoomRadius = Algos.formatDistance(info[0])
        zoomCircle = (scaleImage.sourceSize.width * info[1]) //border.width 3
    }

    function setZoomScale(){
        var info = calculateScale(scaleImage.sourceSize.width,0)
        scaleText.text = Algos.formatDistance(info[0])
        scaleImage.width = (scaleImage.sourceSize.width * info[1]) - 2 * scaleImageLeft.sourceSize.width
    }

    function centerMapRegion(markers){
        var region

        if(markers.length === 1){
            region = QtPositioning.circle(markers[0],500)
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
        plugin: Plugin{
            name:"mapboxgl"
            PluginParameter{name:"mapboxgl.access_token";value:"pk.eyJ1IjoidGltb3RoeWx1ZWQiLCJhIjoiY2swNTd4N3pyMDQ1djNjcWk3YWk1Mmw4aiJ9.peN9sLC_oLX5m-KOT5RTlA"}
            PluginParameter{name:"mapboxgl.mapping.additional_style_urls"; value:"mapbox://styles/timothylued/ck06pdqf709ea1do535fgthp6"} //outdoors
            //mapbox://styles/timothylued/ck058xmm809nc1co4193k21g0

        }
        activeMapType: supportedMapTypes[0]
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
            win.setCircleScale(zoomOffset)
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
                if (movingMarker!=-1){
                    onMapWpModel.set(movingMarker,{"name":onMapWpModel.get(movingMarker).name,"lat":cor.latitude.toString(),"lon":cor.longitude.toString()})
                    routeEditPoly.update()
                    //update coordinate in WP Panel
                    wpModel.set(movingMarker,{"name":wpModel.get(movingMarker).name,"lat":onMapWpModel.get(movingMarker).lat,"lon":onMapWpModel.get(movingMarker).lon})

                }
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
            anchors{
                bottom: parent.bottom;
                right: parent.right
                margins: 10
            }

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
            anchors{
                top: parent.top
                right: parent.right
                margins: 10
            }
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

        Item {
            width:txt.implicitWidth
            height:txt.implicitHeight

            anchors{
                margins: 10
                right: infobar.left
                verticalCenter: infobar.verticalCenter
            }

            Text{
                id: txt
                text: "\u29BD"
                font.pixelSize: 25
                color: "#004EAE"
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                anchors.fill: parent
            }

            transform: Rotation {
                origin.x: txt.implicitWidth/2
                origin.y: txt.implicitHeight/2
                angle: 360 - map.bearing
                Behavior on angle {
                    RotationAnimation{
                        id:rotAni
                        duration: 100
                        direction: RotationAnimation.Shortest
                        easing.type: Easing.Linear
                    }
                }
            }
        }

        MapItemView{
            id: droneObjects
            model: dronemodel

            delegate:MapItemGroup{

                Drone{
                    id: droneBody
                    z:2
                    droneColor: colorInfo
                    extrapolating: extrapolateInfo
                    droneId: idInfo
                    extrapolationTime: 1000
                    visible: visibleInfo
                    trackingHistory: trackingHistoryInfo

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
                            staticPath.mPath = []
                            if (historyInfo.length > 1) staticPath.mPath = historyInfo
                            k = 50
                        }
                    }
                    property int k: 50
                    onCoordinateChanged: {
                        var n,first, second

                        if (trackingHistory) {
                            n = dynamicPath.pathLength()

                            if (k == 50){//every 50th or corner
                                if(n <= 100){
                                    dynamicPath.addCoordinate(posInfo)
                                    k = 0
                                }else{//max pathLength
                                    dynamicPath.path = []
                                    staticPath.mPath = historyInfo
                                    k = 50
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
                            var region = centerMapRegion(dronemodel.getAllDronePos())
                            map.fitViewportToGeoShape(region,200)
                        }
                    }
                }


                MapQuickItem{
                    id:circleRuler
                    z:1
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
                            text: zoomRadius
                            font.bold: true
                            anchors.horizontalCenter: parent.horizontalCenter
                            anchors.bottom: parent.top
                            renderType: Text.NativeRendering
                        }
                    }
                    Component.onCompleted: win.setCircleScale(zoomOffset)
                }

                MapQuickItem {//PopUp
                    visible: droneBody.popUp && visibleInfo
                    coordinate: droneBody.coordinate
                    z: 2
                    anchorPoint.x: if (!followInfo) {-10}else{-droneBody.width / 2}
                    anchorPoint.y: if (!followInfo) {-10}else{popItem.height / 2}

                    sourceItem: Item{
                        id:popItem
                        width: 100
                        height: 100

                        Rectangle{anchors.fill: parent; color: "white"; opacity: 1}


                        Rectangle{
                            anchors.fill: parent
                            anchors.margins: 5

                            RowLayout {
                                id: popHeader
                                anchors.margins: 2
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
                                        id:closeBtn
                                        onClicked: droneBody.popUp = !droneBody.popUp

                                        background: Rectangle {
                                            implicitWidth: contentItem.implicitWidth
                                            implicitHeight: contentItem.implicitHeight
                                            border.color: closeBtn.down ? "#3EC6AA" : "black"
                                            border.width: 1
                                            radius: 2
                                        }

                                        contentItem: Text {
                                            text: "x"
                                            font.pixelSize: 10
                                            horizontalAlignment: Text.AlignHCenter
                                            color: closeBtn.down ? "#3EC6AA" : "black"
                                            elide: Text.ElideRight
                                        }

                                    }
                                }
                            }

                            Flickable {
                                id: fparent
                                anchors{
                                    bottom: parent.bottom
                                    top: popHeader.bottom
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


                HistoryPoly{//Static
                    id: staticPath
                    visible: trackingHistoryInfo&& visibleInfo
                    line.color: colorInfo
                    line.width: 1
                }

                MapPolyline{//dynamic
                    id: dynamicPath
                    visible: trackingHistoryInfo&& visibleInfo
                    line.color: colorInfo
                    line.width: 1
                }

                MapPolyline{
                    id: routePoly
                    visible: showingRouteInfo&& visibleInfo
                    path: routeInfo
                    line.color: colorInfo
                    line.width: 1
                }

                MapPolyline{
                    id: hotLegPoly
                    visible: showingRouteInfo&& visibleInfo
                    path: legInfo
                    line.color: colorInfo
                    line.width: 3
                }

            }

        }

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
                                if(movingMarker==-1){movingMarker = index}else{movingMarker = -1}
                            }
                        }

                    }

                }

            }
        }


        WaypointPanel{
            id: wpPanel

            anchors{
                right: actionPanel.left
                rightMargin: 26
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
                for (var i = 0; i<wpModel.count;i++){
                    onMapWpModel.append(wpModel.get(i))
                }
                routeEditPoly.update()
            }
        }


        DronePanel{id:dronePanel}
        ActionPanel{id:actionPanel}
        NotificationPanel{id:notifyPanel;Component.onCompleted: show()}

    }

}

