import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12


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
        }

        ScrollView {
            Layout.fillWidth: true
            Layout.fillHeight: true

            ListView {
                id: listView
                clip: true
                model: myModel
                delegate: WaypointDraggableItem {
                    Rectangle {
                        height: textLabel.height * 2
                        width: listView.width
                        color: "white"

                        Text {
                            id: textLabel
                            anchors.centerIn: parent
                            text: model.text
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

                    draggedItemParent: mainContent

                    onMoveItemRequested: {
                        myModel.move(from, to, 1);
                    }
                }
            }
        }
    }

    ListModel {
        id: myModel
        ListElement {
            text: "Alpha"
        }
        ListElement {
            text: "Bravo"
        }
        ListElement {
            text: "Charlie"
        }
    }

}

