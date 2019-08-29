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
    property bool editing: false
    visible: false

    function show(){content.visible = true}
    function hide(){content.visible = false}

    width: 200
    height: 400

    Rectangle{
        anchors.fill:parent
        color:"white"
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        Rectangle {
            color: "#3EC6AA"
            height: 30
            Layout.fillWidth: true

            Text {
                anchors.centerIn: parent
                text: droneId
                font.letterSpacing: 2
            }

            Text{
                text: "X"
                anchors.right: parent.right
                anchors.rightMargin: 20
                height: parent.height
                verticalAlignment: Text.AlignVCenter
                MouseArea{
                    anchors.fill:parent
                    onClicked: {hide()}
                }
            }

        }

        ScrollView {
            Layout.fillWidth: true
            Layout.fillHeight: true

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
                            //anchors.centerIn: parent
                            anchors.verticalCenter: parent.verticalCenter
                            leftPadding: 5
                            text: (index+1) + ". " + (name!=""? name : Algos.roundNumber(lat,3) + ", " + Algos.roundNumber(lon,3))
                        }

                        TextField{
                            id: wpTextField
                            visible: editing
                            anchors.fill: parent
                            text: name!=""? name : Algos.roundNumber(lat,3) + ", " + Algos.roundNumber(lon,3)
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
                            visible: editing
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
                        map.fitViewportToGeoShape(region,80)
                    }

                    draggedItemParent: content

                    onMoveItemRequested: {
                        wpModel.move(from, to, 1);
                        onMapWpModel.update()
                    }
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
        highlighted: editing
        onClicked: editing = !editing
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
            map.fitViewportToGeoShape(region,200)
        }
    }
    Button{
        id: applyChangesBtn
        anchors{
            bottom: parent.bottom
            left: parent.left
            margins: 5
        }
        palette {button: "#3EC6AA"}
        text: "Apply"
        font.pixelSize: 16
        height: contentItem.implicitHeight + topPadding + bottomPadding
        width: contentItem.implicitWidth + leftPadding + rightPadding
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

