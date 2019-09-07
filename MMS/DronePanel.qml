import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Controls.Styles 1.4
import QtQuick.Window 2.12
import "algos.js" as Algos



Item{
    id: dronePanel
    property bool shown: true
    width: shown ? 150 : 0
    property variant colors: ["red","blue","green","purple","darkorange","darkred","fuchsia"]

    anchors{
        top: parent.top
        bottom: parent.bottom
        left: parent.left
        leftMargin: 20
        topMargin: 20
        bottomMargin: 20
    }

    Behavior on width{
        PropertyAnimation{
            duration: 500
            easing.type: Easing.Linear
        }
    }

    Rectangle{//Closer
        anchors{
            verticalCenter: parent.verticalCenter
            left: panelBG.right
        }
        width: 20
        height: 80
        color: panelBG.color
        Text{
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter
            horizontalAlignment: Text.AlignHCenter
            width: contentItem.implicitWidth
            font.pixelSize: 25
            font.bold: true
            text: shown? "\u25C1" : "\u25B7"

        }
        MouseArea{
            anchors.fill:parent
            onClicked: {shown = !shown}
        }
    }

    Rectangle{
        id:panelBG
        anchors.fill: parent
        opacity: 0.8
        color: "#3EC6AA"
        layer.enabled: true
        property bool uavExtended: true
        property bool groupExtended: true

        Rectangle{
            id: dronesHeader

            property int space: 10
            width: 150
            height: extendBtn.height
            anchors{
                left: parent.left
                top: parent.top
                topMargin: 4
            }
            color:"transparent"

            Rectangle{
                id: extendBtn
                anchors{
                    right: parent.right
                    verticalCenter: parent.verticalCenter
                    rightMargin: 4
                }
                width: 20
                height: 20
                border.color: "white"
                border.width: 1
                color: "transparent"
                radius: 2

                MouseArea{
                    anchors.fill:parent
                    onClicked: {
                        panelBG.uavExtended = !panelBG.uavExtended
                    }
                }
                Text {
                    anchors.fill:parent
                    text: panelBG.uavExtended? "-":"+"
                    font.pixelSize: 16
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    color: "black"
                    elide: Text.ElideRight
                }
            }

            Text{
                id:headerText
                text: "UAV"
                font.pixelSize: 12
                color:"white"
                anchors{
                    left: parent.left
                    right: parent.right
                    verticalCenter: parent.verticalCenter
                }
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
            Rectangle{
                id: leftLine
                height: 1
                width: parent.width / 2 - Algos.calcTxtWidth(headerText.text,headerText) / 2 - parent.space
                color:"white"
                anchors{
                    left: parent.left
                    verticalCenter: parent.verticalCenter
                }
            }
            Rectangle{
                height: 1
                width: leftLine.width-extendBtn.width - extendBtn.anchors.rightMargin
                color:"white"
                anchors{
                    right: extendBtn.left
                    verticalCenter: parent.verticalCenter
                }
            }
        }

        Rectangle{
            id: uavContainer
            layer.enabled: true
            color:"transparent"
            anchors{
                top: dronesHeader.bottom
                left:parent.left
                right:parent.right
                topMargin: 4
            }
            height: panelBG.uavExtended? droneLV.contentHeight:0

            Behavior on height{
                PropertyAnimation{
                    duration: 200
                    easing.type: Easing.Linear
                }
            }

            ListView{
                id: droneLV
                anchors.fill: parent
                clip:true
                model: dronemodel
                delegate: droneLvDelegate
                spacing: 2
            }
        }


        Rectangle{
            id: groupHeader

            property int space: 10
            width: 150
            height: extendGroupBtn.height
            anchors{
                left: parent.left
                top: uavContainer.bottom
                topMargin: 4
            }
            color:"transparent"



            Rectangle{
                id: extendGroupBtn
                anchors{
                    right: parent.right
                    verticalCenter: parent.verticalCenter
                    rightMargin: 4
                }
                width: 20
                height: 20
                border.color: "white"
                border.width: 1
                color: "transparent"
                radius: 2

                MouseArea{
                    anchors.fill:parent
                    onClicked: {
                        panelBG.groupExtended = !panelBG.groupExtended
                    }
                }
                Text {
                    anchors.fill:parent
                    text: panelBG.groupExtended? "-":"+"
                    font.pixelSize: 16
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    color: "black"
                    elide: Text.ElideRight
                }
            }

            Text{
                id:headerGroupText
                text: "Groups"
                font.pixelSize: 12
                color:"white"
                anchors{
                    left: parent.left
                    right: parent.right
                    verticalCenter: parent.verticalCenter
                }
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
            Rectangle{
                id: leftGroupLine
                height: 1
                width: parent.width / 2 - Algos.calcTxtWidth(headerGroupText.text,headerGroupText) / 2 - parent.space
                color:"white"
                anchors{
                    left: parent.left
                    verticalCenter: parent.verticalCenter
                }
            }
            Rectangle{
                height: 1
                width: leftGroupLine.width-extendGroupBtn.width - extendGroupBtn.anchors.rightMargin
                color:"white"
                anchors{
                    right: extendGroupBtn.left
                    verticalCenter: parent.verticalCenter
                }
            }
        }


        Rectangle{
            id: groupContainer
            layer.enabled: true
            color:"transparent"
            anchors{
                top: groupHeader.bottom
                left:parent.left
                right:parent.right
                topMargin: 4
            }
            height: panelBG.groupExtended? groupLV.contentHeight:0

            Behavior on height{
                PropertyAnimation{
                    duration: 200
                    easing.type: Easing.Linear
                }
            }

            ListView{
                id: groupLV
                anchors.fill: parent
                clip:true
                //model: dronemodel
                //delegate: droneLvDelegate
                spacing: 2
            }
        }



    }


    Component{
        id: droneLvDelegate
        Item{
            id: listItem
            width: parent.width
            height: small

            Rectangle{
                //opacity: 0.5
                anchors.fill: parent
                color: "white"

                MouseArea {
                    hoverEnabled: true
                    anchors.fill: parent

                    onClicked: {
                        if(listItem.height === small){listItem.height = enlarged
                        }else{listItem.height = small}
                    }
                }
            }

            Column{
                id: mainColumn
                spacing: 2
                layer.enabled: true

                anchors{
                    fill: parent
                    leftMargin: 10
                    rightMargin: 10
                    topMargin: 5
                    bottomMargin: 5
                }

                Row{
                    id: row0
                    Label{
                        id: lbl1
                        text: idInfo
                        color: if(visibleInfo) {colorInfo}else{"grey"}
                        font.pixelSize: txtSize
                        wrapMode: Text.WrapAnywhere
                        width: 150 -parent.anchors.leftMargin
                        renderType: Text.NativeRendering
                    }
                }



                Row{
                    id: row1
                    spacing: 2

                    Rectangle{
                        id: historyBtn
                        width: Algos.calcTxtWidth(historyText.text,historyText) + 10

                        MouseArea{
                            anchors.fill:parent
                            onClicked: {
                                dronemodel.toggleHistoryTracking(idInfo)
                            }
                        }
                        height: 20
                        border.color: historyText.color
                        border.width: 1
                        color: "transparent"
                        Text {
                            id:historyText
                            text: "History"
                            anchors.fill:parent
                            font.pixelSize: 12
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                            color: trackingHistoryInfo? "#3EC6AA" : "black"
                            elide: Text.ElideRight
                        }
                    }

                    Rectangle{
                        id: routeBtn
                        width: Algos.calcTxtWidth(routeText.text,routeText) + 10

                        MouseArea{
                            anchors.fill:parent
                            onClicked: {
                                dronemodel.toggleShowingRoute(idInfo)
                            }
                        }
                        height: 20
                        border.color: routeText.color
                        border.width: 1
                        color: "transparent"
                        Text {
                            id:routeText
                            text: "Route"
                            anchors.fill:parent
                            font.pixelSize: 12
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                            color: showingRouteInfo? "#3EC6AA" : "black"
                            elide: Text.ElideRight
                        }
                    }
                }

                Row{
                    id: row2
                    spacing: 2

                    Rectangle{
                        id: editBtn
                        width: Algos.calcTxtWidth(editText.text,editText) + 10

                        MouseArea{
                            anchors.fill:parent
                            onClicked: {
                                if(showingRouteInfo) dronemodel.toggleShowingRoute(idInfo)
                                wpModel.clear()
                                for (var i = 0;i<wpInfo.length;i++){
                                    wpModel.append({"name":wpInfo[i].id,"lat":wpInfo[i].lat,"lon":wpInfo[i].lon})
                                }
                                onMapWpModel.update()

                                wpPanel.droneId = idInfo
                                wpPanel.show()
                            }
                        }
                        height: 20
                        border.color: editText.color
                        border.width: 1
                        color: "transparent"
                        Text {
                            id:editText
                            text: "\u26ED"
                            anchors.fill:parent
                            font.pixelSize: 12
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                            color: "black"
                            elide: Text.ElideRight
                        }
                    }


                    Rectangle{
                        id: followBtn
                        width: Algos.calcTxtWidth(followText.text,followText) + 10

                        MouseArea{
                            anchors.fill:parent
                            onClicked: {
                                dronemodel.toggleFollow(idInfo)
                            }
                        }
                        height: 20
                        border.color: followText.color
                        border.width: 1
                        color: "transparent"
                        Text {
                            id:followText
                            text: "\u2B9D"
                            anchors.fill:parent
                            font.pixelSize: 12
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                            color: followInfo? "#3EC6AA" : "black"
                            elide: Text.ElideRight
                        }
                    }

                    Rectangle{
                        id: centerBtn
                        width: Algos.calcTxtWidth(centerText.text,centerText) + 10

                        MouseArea{
                            anchors.fill:parent
                            onClicked: {
                                if (!map.isCenterOnAll) {
                                    var region = centerMapRegion([posInfo])
                                    map.fitViewportToGeoShape(region,200)
                                }
                            }
                        }
                        height: 20
                        border.color: centerText.color
                        border.width: 1
                        color: "transparent"
                        Text {
                            id:centerText
                            text: "\u29BF"
                            anchors.fill:parent
                            font.pixelSize: 12
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                            color: "black"
                            elide: Text.ElideRight
                        }
                    }

                    Rectangle{
                        id: visibleBtn
                        width: Algos.calcTxtWidth(visibleText.text,visibleText) + 20

                        MouseArea{
                            anchors.fill:parent
                            onClicked: {
                                if (visibleInfo) {dronemodel.setVisibility(idInfo,false)}else{dronemodel.setVisibility(idInfo,true)}
                            }
                        }
                        height: 20
                        border.color: visibleText.color
                        border.width: 1
                        color: "transparent"
                        Text {
                            id:visibleText
                            text: "\u20E0"
                            anchors.fill:parent
                            font.pixelSize: 12
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                            color: !visibleInfo? "#FF5733" : "black"
                            elide: Text.ElideRight
                        }
                    }


                    ComboBox{
                        id: cbColor
                        enabled: listItem.height === enlarged ? true : false

                        background: Rectangle{
                            id: cbBG
                            implicitWidth: 30
                            implicitHeight: historyBtn.height
                            radius: 2
                            border.width: 1
                        }

                        delegate: ItemDelegate {
                            contentItem: Rectangle {
                                anchors.fill: parent
                                color: modelData
                            }
                        }

                        indicator: Canvas {}
                        contentItem: Text {}


                        property bool initial:false

                        model: ListModel{id: colorModel}

                        Component.onCompleted: {
                            for (var k = 0;k<colors.length;k++){
                                colorModel.append(({"color": colors[k]}))
                            }
                            currentIndex = find(colorInfo)
                            cbBG.color = colorInfo
                            initial = true
                        }
                        onCurrentIndexChanged: {
                            if (initial){
                                dronemodel.setColor(idInfo,colorModel.get(currentIndex).color)
                                cbBG.color = colorModel.get(currentIndex).color
                            }
                        }

                    }

                }

                Row{
                    id: row3
                    spacing: 2

                    ComboBox{ //available data to display
                        id: dataCB

                        //enabled: listItem.height === enlarged ? true : false
                        model: infoNamesInfo

                        indicator: Canvas {
                            id: canvas
                            x: dataCB.width - width - dataCB.rightPadding
                            y: dataCB.topPadding + (dataCB.availableHeight - height) / 2
                            width: 12
                            height: 8
                            contextType: "2d"

                            Connections {
                                target: dataCB
                                onPressedChanged: canvas.requestPaint()
                            }

                            onPaint: {
                                context.reset();
                                context.moveTo(0, 0);
                                context.lineTo(width, 0);
                                context.lineTo(width / 2, height);
                                context.closePath();
                                context.fillStyle = "grey";
                                context.fill();
                            }
                        }

                        contentItem: Text {
                            leftPadding: 5
                            rightPadding: dataCB.indicator.width + dataCB.spacing
                            text: dataCB.displayText
                            color: "BLACK"
                            verticalAlignment: Text.AlignVCenter
                            elide: Text.ElideRight
                        }

                        background: Rectangle {
                            implicitWidth: 80
                            implicitHeight: historyBtn.height
                            border.color: "black"
                            border.width: 1
                        }

                    }


                    Rectangle{
                        id: plusBtn
                        width: Algos.calcTxtWidth(plusText.text,plusText) + 10

                        MouseArea{
                            anchors.fill:parent
                            onClicked: {
                                if (dataCB.currentIndex!=-1) dronemodel.setSelectedInfoList(idInfo,dataCB.currentText)
                            }
                        }
                        height: 20
                        border.color: plusText.color
                        border.width: 1
                        color: "transparent"
                        Text {
                            id:plusText
                            text: "+"
                            anchors.fill:parent
                            font.pixelSize: 12
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                            color: "black"
                            elide: Text.ElideRight
                        }
                    }

                    Rectangle{
                        id: minusBtn
                        width: plusBtn.width

                        MouseArea{
                            anchors.fill:parent
                            onClicked: {
                                if (dataCB.currentIndex!=-1) dronemodel.setUnselectedInfoList(idInfo,dataCB.currentText)
                            }
                        }
                        height: 20
                        border.color: plusText.color
                        border.width: 1
                        color: "transparent"
                        Text {
                            id:minusText
                            text: "-"
                            anchors.fill:parent
                            font.pixelSize: 12
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                            color: "black"
                            elide: Text.ElideRight
                        }
                    }
                }


                Flickable  {
                    id: fparent
                    height: parent.height - row0.height- row1.height- row2.height- row3.height -4*2
                    width: 130
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
                                    spacing: 3

                                    Text{
                                        id: keyText
                                        text: infoSelectedNamesInfo[index]
                                        wrapMode: Text.WrapAnywhere
                                        width: dataLV.columnWidths
                                        renderType: Text.NativeRendering
                                    }
                                    Loader { sourceComponent: columnSeparator; height: keyText.height>valueText.height?keyText.height:valueText.height}
                                    Text{
                                        id: valueText
                                        text: infoSelectedValuesInfo[index]
                                        wrapMode: Text.WrapAnywhere
                                        width: parent.width - dataLV.columnWidths
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


}
