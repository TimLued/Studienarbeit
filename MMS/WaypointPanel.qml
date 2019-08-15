import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import QtPositioning 5.13
import "algos.js" as Algos

Item {
    id: mainContent

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
                text: "Waypoints"
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
                    onClicked: {}
                }
            }

        }

        // Header
//        RowLayout {
//            spacing: 0
//            width: parent.width

//            Rectangle{
//                color: "#3EC6AA"
//                height: 30
//                Layout.fillWidth: true
//                Layout.alignment: Qt.AlignLeft
//                Text{
//                    text: "Waypoints"
//                    anchors.centerIn: parent
//                    font.letterSpacing: 2
//                }
//            }
//            Rectangle{
//                color: "#3EC6AA"
//                height: 30
//                width: 50
//                Layout.alignment: Qt.AlignRight

//                Text{
//                    text: "X"
//                    //anchors.margins: 5
//                    anchors.centerIn: parent
//                }
//            }
//        }




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
                            text: (index+1) + ". " + (name? name : Algos.roundNumber(lat,3) + ", " + Algos.roundNumber(lon,3))
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

                    property variant region
                    onMeClicked: {
                        region = QtPositioning.circle(QtPositioning.coordinate(onMapWpModel.get(index).lat,onMapWpModel.get(index).lon),500)
                        map.fitViewportToGeoShape(region,80)
                    }

                    draggedItemParent: mainContent

                    onMoveItemRequested: {
                        wpModel.move(from, to, 1);
                        onMapWpModel.update()
                    }

                }

//                highlightFollowsCurrentItem: false
//                focus: true
//                highlight: Component{
//                    Rectangle{
//                        width: listView.width
//                        height:
//                        color: "#3EC6AA"
//                        opacity: 0.5
//                        y: listView.currentItem.y
//                    }}

            }
        }
    }

    RoundButton{
        anchors{
            bottom: parent.bottom
            right: parent.right
            margins: 5
        }
        radius: 20
        palette {button: "#3EC6AA"}
        text: "+"
        font.pixelSize: txtSize
        highlighted: map.setWaypoints
        onClicked: map.setWaypoints = !map.setWaypoints

    }

}

