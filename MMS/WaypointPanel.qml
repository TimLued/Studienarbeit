import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import QtPositioning 5.13
import QtLocation 5.13
import QtQuick.Controls.Styles 1.4
import "algos.js" as Algos
import Controller 1.0

Item {
    id: content

    property string droneId
    property int mHeight: listView.contentHeight + header.height + centerWpBtn.height + centerWpBtn.anchors.margins * 2


    visible: false
    function show(){content.visible = true}
    function hide(){content.visible = false}

    width: 200
    height: mHeight < (win.height*0.7)?  mHeight:win.height*0.7

    onDroneIdChanged: routeEditPoly.update(droneId)

    Rectangle{
        anchors.fill:parent
        color:"white"
        opacity: 0.8
    }

    Rectangle {
        id: header
        color: "#3EC6AA"
        height: 30
        width:parent.width

        Text {
            anchors.centerIn: parent
            text: droneId
            font.pixelSize: 14
            font.letterSpacing: 2
        }

        Text{
            text: "X"
            font.pixelSize: 16
            anchors.right: parent.right
            anchors.rightMargin: 20
            height: parent.height
            verticalAlignment: Text.AlignVCenter
            MouseArea{
                anchors.fill:parent
                onClicked: {
                    wpModel.clear()
                    onMapWpModel.update()
                    map.setWaypoints = false
                    hide()
                }
            }
        }

    }

    ScrollView {
        width: parent.width
        anchors.top: header.bottom
        anchors.bottom: centerWpBtn.top

        ListView {
            id: listView
            clip: true
            model: wpModel

            delegate: WaypointDraggableItem {
                id: listItemMechanic
                Rectangle {
                    id: listItemBody
                    height: textLabel.height * 2
                    width: listView.width
                    color: listItemMechanic.mouseHover? "#3EC6AA":"white"

                    Text {
                        id: textLabel
                        anchors.verticalCenter: parent.verticalCenter
                        leftPadding: 5
                        text: (index+1) + ". " + (name!=""? name : Algos.roundNumber(lat,3) + ", " + Algos.roundNumber(lon,3))
                    }

                    TextField{
                        id: wpTextField
                        visible: editWpBtn.checked
                        anchors.fill: parent
                        text: name!=""? name : Algos.roundNumber(lat,3) + ", " + Algos.roundNumber(lon,3)
                        selectByMouse: true
                        background: Rectangle {
                            border.width: 0
                        }
                        onVisibleChanged: {
                            if (!wpTextField.visible){
                                wpModel.set(index,{"name":wpTextField.text,"lat":lat,"lon":lon})
                                onMapWpModel.set(index,{"name":wpTextField.text,"lat":onMapWpModel.get(index).lat,"lon":onMapWpModel.get(index).lon})
                            }
                        }
                    }

                    Text{
                        text: "X"
                        color: "#FF5733"
                        visible: editWpBtn.checked
                        anchors{
                            right: parent.right
                            verticalCenter: parent.verticalCenter
                            rightMargin: 20
                        }
                        height: parent.height
                        verticalAlignment: Text.AlignVCenter
                        MouseArea{
                            anchors.fill:parent
                            onClicked: {
                                wpModel.remove(index)
                                onMapWpModel.update()
                            }
                        }
                    }

                    // Bottom line border
                    Rectangle {
                        anchors {
                            left: parent.left
                            right: parent.right
                            bottom: parent.bottom
                        }
                        height: 1
                        color: "lightgrey"
                    }

                }

                onMeClicked: {
                    var region = QtPositioning.circle(QtPositioning.coordinate(onMapWpModel.get(index).lat,onMapWpModel.get(index).lon),500)
                    map.fitViewportToGeoShape(region,100)
                }

                draggedItemParent: content

                onMoveItemRequested: {
                    wpModel.move(from, to, 1);
                    onMapWpModel.update()
                }
            }
        }
    }




    RoundButton{
        id: addWpBtn
        anchors{
            bottom: parent.bottom
            right: parent.right
            margins: 5
        }
        width: 35
        height: width
        radius: width / 2
        palette {button: "#3EC6AA"}
        text: "+"
        font.pixelSize: txtSize
        highlighted: map.setWaypoints
        onClicked: map.setWaypoints = !map.setWaypoints
    }

    RoundButton{
        id: editWpBtn
        anchors{
            bottom: parent.bottom
            right: addWpBtn.left
            margins: 5
        }
        palette {button: "#3EC6AA"}
        text: "\u26ED"
        font.pixelSize: 16
        width: 35
        height: width
        radius: width / 2
        checkable: true
        highlighted: editWpBtn.checked
    }

    RoundButton{
        id: centerWpBtn
        anchors{
            bottom: parent.bottom
            right: editWpBtn.left
            margins: 5
        }
        palette {button: "#3EC6AA"}
        text: "\u29BF"
        font.pixelSize: 16
        width: 35
        height: width
        radius: width / 2
        onClicked: {
            var region = centerMapRegion(routeEditPoly.path)
            map.fitViewportToGeoShape(region,100)
        }
    }
    RoundButton{
        id: applyChangesBtn
        anchors{
            bottom: parent.bottom
            left: parent.left
            margins: 5
        }
        palette {button: "#3EC6AA"}
        text: "\u2713"
        font.pixelSize: 16
        width: 35
        height: width
        radius: width / 2
        onClicked: {
            var jString = '{"drone": ['
            for (var i=0;i<wpModel.count;i++){
                jString+='{"id":"'+wpModel.get(i).name+'","lat":"'+wpModel.get(i).lat + '","lon":"'+wpModel.get(i).lon+ '","drone":"'+droneId+'"}'
                if(i<wpModel.count-1) jString += ','
            }
            jString+=']}'
            controller.task = jString
        }
    }

    Controller{
        id: controller

    }


}

