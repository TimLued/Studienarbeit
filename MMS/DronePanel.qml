import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Window 2.12
import "algos.js" as Algos

Item{
    id: dronePanel
    width: 150
    opacity: 0.7
    property variant colors: ["red","blue","green","purple","yellow","cyan","coral","chartreuse","darkorange","darkred","fuchsia"]

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
    }


    Component{
        id: listDelegate
        Item{
            id: listItem
            width: parent.width
            height: small
            //layer.enabled: true

            Rectangle{
                anchors.fill: parent
                //opacity: 0.3

                color: "white"

                MouseArea {
                    hoverEnabled: true
                    anchors.fill: parent

                    onClicked: {
                        if(listItem.height === small){listItem.height = enlarged
                        }else{listItem.height = small}
                    }

                    onEntered: list.currentIndex = index
                    onExited: list.currentIndex = -1
                }
            }
            Rectangle{ //on item selected
                id: itemSelect
                anchors.fill: parent
                visible: false
                opacity: 0.3
                color: "grey"
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
                Text{text: idInfo; color: colorInfo; font.pixelSize: txtSize;wrapMode: Text.WordWrap; width: parent.width}
                //                        Text{text: droneID; font.pixelSize: txtSize; font.underline: drones[index].marked; font.bold: drones[index].marked; wrapMode: Text.WordWrap; width: parent.width}
                //                        Text{text: "Lat: " + lat; font.pixelSize: txtSize; wrapMode: Text.WordWrap; width: parent.width}
                //                        Text{text: "Lon: " + lon; font.pixelSize: txtSize; wrapMode: Text.WordWrap; width: parent.width}
                //                        Text{text: "Speed: " + speed + " m/s"; font.pixelSize: txtSize; wrapMode: Text.WordWrap; width: parent.width}
                //                        Text{text: "Mission: Transition"; font.pixelSize: txtSize; wrapMode: Text.WordWrap; width: parent.width}


                Row{
                    visible: if(listItem.height === enlarged){true}else{false}
//                    spacing: 5
//                    Button{
//                        //\u2295
//                        //\u2A01
//                        //\u2B99
//                        text: "Follow"
//                        height: 20
//                        width: 50
//                        font.pixelSize: 11
//                        highlighted: win.drones[index].follow
//                        enabled: if(listItem.height === enlarged){true}else{false}

//                        onClicked:{
//                            if (win.drones[index].follow){
//                                win.drones[index].follow = false
//                            }else{
//                                for (var m = 0; m<win.drones.length;m++){
//                                    win.drones[m].follow = false
//                                }
//                                win.drones[index].follow = true
//                                map.center =win.drones[index].coordinate
//                            }
//                        }
//                    }
//                    Button{
//                        // U+20E0
//                        //U+26C4
//                        text: "Visible"
//                        height: 20
//                        width: 50
//                        font.pixelSize: 11
//                        highlighted: win.drones[index].visible
//                        enabled: if(listItem.height === enlarged){true}else{false}

//                        onClicked:{
//                            win.drones[index].visible = !win.drones[index].visible
//                        }
//                    }
                }
                Row{
                    visible: if(listItem.height === enlarged){true}else{false}
                    spacing: 5
                    layer.enabled: true
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
                            currentIndex = find(colorInfo)
                            initial = true
                        }
                        onCurrentIndexChanged: {
                            if (initial){
                                dronemodel.setColor(idInfo,colorModel.get(currentIndex).color)
                                if (followInfo){
                                    map.removeTrail()
                                    map.updateStaticPath(idInfo,colorInfo,posInfo)
                                }
                            }
                        }

                    }
                    Button{
                        //U+22B8
                        text: "History"
                        height: 20
                        width: 50
                        font.pixelSize: 12
                        highlighted: followInfo
                        enabled: if(listItem.height === enlarged){true}else{false}
                        property int tmp
                        onClicked:{
                            map.removeTrail()
                            if (!followInfo) map.updateStaticPath(idInfo,colorInfo,posInfo)
                            dronemodel.updateDrone(idInfo,posInfo,true)
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
        model: dronemodel
        delegate: listDelegate
        highlight: mark
        highlightFollowsCurrentItem: true
        highlightMoveVelocity: -1
        highlightResizeVelocity: -1
        Component.onCompleted: currentIndex = -1
    }

}
