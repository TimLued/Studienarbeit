import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Controls.Styles 1.4
import QtQuick.Window 2.12
import "algos.js" as Algos



Item{
    id: dronePanel
    property bool shown: true
    width: shown ? 150 : 0
    property variant colors: ["red","blue","green","purple","yellow","cyan","coral","chartreuse","darkorange","darkred","fuchsia"]
    function noMark(){list.currentIndex = -1}

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

    Rectangle{
        id:panelBG
        anchors.fill: parent
        opacity: 1.0
        color: "#3EC6AA"
        MouseArea {
            hoverEnabled: true
            anchors.fill: parent
            onEntered: list.currentIndex = -1
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
            width: parent.width
            font.pixelSize: 25
            font.bold: true
            text: shown? "\u25C1" : "\u25B7"
            horizontalAlignment: Text.AlignHCenter
        }
        MouseArea{
            anchors.fill:parent
            onClicked: {shown = !shown}
        }
    }


    Component{
        id: listDelegate
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

                    onEntered: list.currentIndex = index
                }
            }

            Column{
                id: mainColumn
                spacing: 5
                layer.enabled: true

                anchors{
                    fill: parent
                    leftMargin: 10
                    rightMargin: 10
                    topMargin: 5
                    bottomMargin: 5
                }

                Label{
                    id: lbl1
                    text: idInfo
                    color: if(visibleInfo) {colorInfo}else{"grey"}
                    font.pixelSize: txtSize
                    wrapMode: Text.WrapAnywhere
                    width: 150 -parent.anchors.leftMargin
                    renderType: Text.NativeRendering
                }

                Row{
                    id: row1
                    //visible: if(listItem.height === enlarged){true}else{false}
                    spacing: 5

                    Button{//History
                        text: "H"
                        height: 20
                        width: contentItem.implicitWidth + leftPadding + rightPadding
                        font.pixelSize: 12
                        highlighted: trackingHistoryInfo
                        enabled: listItem.height === enlarged ? true : false
                        onClicked:{
                            dronemodel.toggleHistoryTracking(idInfo)
                        }
                    }

                    Button{//Route
                        text: "R"
                        height: 20
                        width: contentItem.implicitWidth + leftPadding + rightPadding
                        font.pixelSize: 12
                        highlighted: showingRouteInfo
                        enabled: listItem.height === enlarged ? true : false
                        onClicked:{
                            dronemodel.toggleShowingRoute(idInfo)
                            if(showingRouteInfo && wpInfo.length>0) {
                                for (var i = wpInfo.length-1;i>=0;i--){
                                    wpModel.append({"name":"","lat":wpInfo[i].lat,"lon":wpInfo[i].lon})
                                }
                                onMapWpModel.update()

                                wpPanel.droneId = idInfo
                                wpPanel.show()
                            }else if(wpInfo.length===0){
                                wpPanel.droneId = idInfo
                                wpPanel.show()
                            }else{
                                wpModel.clear()
                                onMapWpModel.update()
                                wpPanel.hide()
                            }
                        }
                    }

                    Button{//Follow
                        text: "\u29BF"
                        height: 20
                        width: contentItem.implicitWidth + leftPadding + rightPadding
                        font.pixelSize: 12
                        highlighted: followInfo
                        enabled: listItem.height === enlarged ? true : false
                        onClicked:{
                            if (!map.isCenterOnAll) {
                                dronemodel.toggleFollow(idInfo)
                                if (!followInfo) map.bearing=0
                            }
                        }
                    }

                    Button{//Visible
                        text: "\u20E0"
                        height: 20
                        width: contentItem.implicitWidth + leftPadding + rightPadding
                        font.pixelSize: 12
                        highlighted: !visibleInfo
                        enabled: listItem.height === enlarged ? true : false
                        onClicked:{
                            if (visibleInfo) {dronemodel.setVisibility(idInfo,false)}else{dronemodel.setVisibility(idInfo,true)}
                        }
                    }

                    ComboBox{
                        id: cbColor
                        height: 20
                        width: 20
                        enabled: listItem.height === enlarged ? true : false
                        font.pixelSize: 10
                        background: Rectangle{
                            id: cbBG
                            anchors.fill: parent
                        }

                        delegate: ItemDelegate {
                            width: 60
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
                    id: row2
                    spacing: 5

                    ComboBox{ //available data to display
                        id: dataCB
                        height: 20
                        width: 80
                        enabled: listItem.height === enlarged ? true : false
                        textRole: "name"
                        font.pixelSize: 10
                        model: ListModel{id: infoNamesModel}

                        property variant infoList
                        onPressedChanged: {
                            if (pressed){
                                infoNamesModel.clear()
                                infoList = dronemodel.getInfoNameList(idInfo)
                                for (var i = 0; i< infoList.length;i++){
                                    infoNamesModel.append({"name": infoList[i]})
                                }
                            }
                        }
                    }

                    Button{// add info displayed
                        text: "+"
                        width: 20
                        height: 20
                        onClicked: {
                            if (dataCB.currentIndex!=-1) dronemodel.setSelectedInfoList(idInfo,infoNamesModel.get(dataCB.currentIndex).name)
                        }
                    }

                    Button{// delete info displayed
                        text: "-"
                        width: 20
                        height: 20
                        onClicked: {
                            if (dataCB.currentIndex!=-1) dronemodel.setUnselectedInfoList(idInfo,infoNamesModel.get(dataCB.currentIndex).name)
                        }
                    }

                }


                Flickable  {
                    id: fparent
                    height: parent.height - lbl1.height - row1.height - row2.height - 3* mainColumn.spacing - 5
                    width: 150
                    interactive: true
                    clip: true
                    flickableDirection: Flickable.VerticalFlick
                    contentHeight: dataLV.height

                    ListView{
                        id: dataLV
                        width: fparent.width - 2
                        height: childrenRect.height
                        clip: true
                        interactive: false
                        spacing: 3
                        model: infoInfo

                        delegate: Text{
                            text: "<b>" + infoInfo[index].name + "</b>: " + infoInfo[index].value
                            wrapMode: Text.WrapAnywhere
                            width: dataLV.width
                            renderType: Text.NativeRendering
                        }

                        onCountChanged: {
                            fparent.returnToBounds();
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
            opacity: 0.4
            color: "grey"
            visible: (list.currentIndex  !== -1)
        }
    }

    ListView{
        id: list
        anchors.fill: parent
        clip:true
        model: dronemodel
        delegate: listDelegate
        //highlight: mark
        highlightFollowsCurrentItem: true
        highlightMoveVelocity: -1
        highlightResizeVelocity: -1
        Component.onCompleted: currentIndex = -1
        spacing: 2
    }


}
