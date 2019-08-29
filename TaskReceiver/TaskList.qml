import QtQuick 2.13
import QtQuick.Controls 2.12
//import QtQuick.Layouts 1.12
import Task 1.0

Frame {
    anchors.fill: parent
    ListView{
        implicitWidth: 250
        implicitHeight: 250
        anchors.fill: parent

        model: TaskModel{
            list: taskList
        }

        delegate: Rectangle{
            width: parent.width
            height: taskText.height
            anchors.margins: 5

            Text{
                id: taskText
                text: "<b>Task " + (index+1) + "</b>: " + model.text
                bottomPadding: 5
                topPadding: 5
                anchors.verticalCenter: parent.verticalCenter
                anchors{
                    left: parent.left
                    right: parent.right
                }

                wrapMode: Text.WrapAnywhere
            }

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
    }
}
