import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Window 2.12
import "algos.js" as Algos

Item{
    id: dronePanel
    width: 150
    opacity: 0.7
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


    Rectangle{
        id:bc
        anchors.fill: parent
        color: "grey"
        MouseArea {
            hoverEnabled: true
            anchors.fill: parent
            onEntered: list.currentIndex = -1
        }
    }


    Component{
        id: listDelegate
        Item{
            id: listItem
            width: parent.width
            height: small

            Rectangle{
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
                spacing: 5
                anchors{
                    fill: parent
                    leftMargin: 10
                    rightMargin: 10
                    topMargin: 5
                    bottomMargin: 5
                }
                Text{text: idInfo; color: colorInfo; font.pixelSize: txtSize;wrapMode: Text.WrapAnywhere; width: parent.width}

                Row{
                    visible: if(listItem.height === enlarged){true}else{false}
                    spacing: 5

                    Button{
                        text: "History"
                        height: 20
                        width: contentItem.implicitWidth + leftPadding + rightPadding
                        font.pixelSize: 12
                        highlighted: trackingHistoryInfo
                        enabled: if(listItem.height === enlarged){true}else{false}
                        onClicked:{
                            dronemodel.toggleHistoryTracking(idInfo)
                        }
                    }

                    Button{
                        text: "Follow"
                        height: 20
                        width: contentItem.implicitWidth + leftPadding + rightPadding
                        font.pixelSize: 12
                        highlighted: followInfo
                        enabled: if(listItem.height === enlarged){true}else{false}
                        onClicked:{
                            dronemodel.toggleFollow(idInfo)
                            if (followInfo) {
                                map.center = posInfo
                                map.centerFollowing = true
                                map.rotating = false
                            }else{
                                map.bearing=0
                                map.centerFollowing = false
                            }
                        }
                    }

                    Button{
                        //Visible
                        //\u20E0
                        //\u26C4
                        text: "\u20E0"
                        height: 20
                        width: contentItem.implicitWidth + leftPadding + rightPadding
                        font.pixelSize: 12
                        highlighted: !visibleInfo
                        enabled: if(listItem.height === enlarged){true}else{false}
                        onClicked:{
                            if (visibleInfo) {dronemodel.setVisibility(idInfo,false)}else{dronemodel.setVisibility(idInfo,true)}
                        }
                    }

                }
                Column{
                    visible: if(listItem.height === enlarged){true}else{false}
                    spacing: 5
                    layer.enabled: true

                    ComboBox{
                        id: cbColor

                        height: 20
                        width: 80
                        enabled: if(listItem.height === enlarged){true}else{false}
                        textRole: "color"
                        font.pixelSize: 10
                        property bool initial:false

                        model: ListModel{
                            id: colorModel
                        }

                        Component.onCompleted: {
                            for (var k = 0;k<colors.length;k++){
                                colorModel.append(({"color": colors[k]}))
                            }
                            currentIndex = find(colorInfo)
                            initial = true
                        }
                        onCurrentIndexChanged: {
                            if (initial){
                                dronemodel.setColor(idInfo,colorModel.get(currentIndex).color)
                            }
                        }
                    }

                    Row{
                        spacing: 5

                        ComboBox{ //available data to display
                            id: dataCB
                            height: 20
                            width: 80
                            enabled: if(listItem.height === enlarged){true}else{false}
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

                        Button{
                            text: "+"
                            width: 20
                            height: 20
                            onClicked: {
                                if (dataCB.currentIndex!=-1) dronemodel.setSeelectedInfoList(idInfo,infoNamesModel.get(dataCB.currentIndex).name)
                            }
                        }

                        Button{
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
                        height: 100
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
                            spacing: 3
                            model: infoInfo

                            delegate: Text{
                                text: "<b>" + infoInfo[index].name + "</b>: " + infoInfo[index].value
                                wrapMode: Text.WrapAnywhere
                                width: dataLV.width
                            }

//                            onModelChanged: {
//                                if(idInfo == dronePop.droneId) dronePop.setModel(dataLV.model)
//                            }

                            onCountChanged: {
                                fparent.returnToBounds();
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
            opacity: 0.8
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
        highlight: mark
        highlightFollowsCurrentItem: true
        highlightMoveVelocity: -1
        highlightResizeVelocity: -1
        Component.onCompleted: currentIndex = -1
    }


}
