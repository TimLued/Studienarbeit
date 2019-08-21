import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import QtPositioning 5.13
import QtLocation 5.13
import "algos.js" as Algos

Item {
    id: content
    property string droneId
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

                    draggedItemParent: content

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
        id: addWpBtn
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

    Button{
        anchors{
            bottom: parent.bottom
            right: addWpBtn.left
            margins: 5
        }
        palette {button: "#3EC6AA"}
        text: "Edit"
        width: contentItem.implicitWidth + leftPadding + rightPadding
        height: 30
    }

}

