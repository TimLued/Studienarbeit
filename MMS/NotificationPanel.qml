import QtQuick 2.12
import QtQuick.Controls 2.12

Item {
    id:notify
    property bool showing: false
    width: 250
    height: showing? 80:0

    function hide(){showing = false}
    function show(){
        notifyText.text = "Some Text Some Text Some Text Some Text Some Text Some Text Some Text Some Text Some Text Some Text Some Text Some Text Some Text Some Text Some Text Some Text Some Text Some Text Some Text Some Text Some Text Some Text Some Text Some Text"
        showing = true
    }

    Behavior on height{
        PropertyAnimation{
            duration: 500
            easing.type: Easing.Linear
        }
    }

    onHeightChanged: if(height == 80) pAnimation.start()

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
        layer.enabled: true

        ScrollView{
            ScrollBar.vertical.policy: ScrollBar.AlwaysOn

            anchors{
                margins: 5
                left: parent.left
                right: closeBtn.left
                top: parent.top
            }
            height: 65

            TextArea{
                id: notifyText
                text: ""
                font.pixelSize: 12
                wrapMode: Text.WrapAnywhere
            }
        }

        ProgressBar {
            id: pBar
            value: 0

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
                bottom: parent.bottom
                bottomMargin: parent.height / 4
            }
            onClicked: {
                hide()
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



    NumberAnimation{
        id: pAnimation
        target: pBar
        property: "value"
        to:1
        duration: 10000
        onFinished: {
            hide()
            pBar.value = 1
        }
    }


}
