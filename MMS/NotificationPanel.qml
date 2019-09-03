import QtQuick 2.12
import QtQuick.Controls 2.12

Item {
    id:notify
    width: 250
    height: 80

    anchors{
        top: parent.top
        horizontalCenter: parent.horizontalCenter
        topMargin: 5
    }

    Rectangle{
        id: background
        anchors.fill: parent
        color: "#3EC6AA"
        radius: 2
        opacity: 0.8
    }
    ScrollView{
        ScrollBar.vertical.policy: ScrollBar.AlwaysOn
        anchors{
            margins: 5
            left: parent.left
            right: closeBtn.left
            top: parent.top
            bottom: pBar.top
        }

        TextArea{
            id: notifyText
            font.pixelSize: 12
            wrapMode: Text.WrapAnywhere
            text:"Some Text Some Text Some Text Some Text Some Text Some Text Some Text Some Text Some Text Some Text Some Text Some Text Some Text Some Text Some Text Some Text Some Text Some Text Some Text Some Text Some Text Some Text Some Text Some Text"

            //        background: Rectangle {
            //            border.color: "transparent"
            //        }
        }
    }


    ProgressBar {
        id: pBar
        value: 0.5
        padding: 2
        anchors{
            left:parent.left
            right:parent.right
            bottom:parent.bottom
            bottomMargin: 4
        }

        background: Rectangle {
            implicitWidth: 200
            implicitHeight: 6
            color: "transparent"
        }

        contentItem: Item {
            implicitWidth: 200
            implicitHeight: 6

            Rectangle {
                width: pBar.visualPosition * parent.width
                height: parent.height
                color: "white"
            }
        }
    }

    Button{
        id: closeBtn
        anchors{
            right: parent.right
            rightMargin: 10
            verticalCenter: parent.verticalCenter
        }
        onClicked: {
            notify.visible = false
        }
        background: Rectangle {
            implicitWidth: 40
            implicitHeight: implicitWidth
            radius: implicitWidth / 2
            color: "transparent"
            border.color: closeBtn.down ? "black" : "white"
            border.width: 1
        }
        contentItem: Text {
            text: "X"
            font.pixelSize: 20
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            color: closeBtn.down ? "black" : "white"
            elide: Text.ElideRight
        }
    }


}
