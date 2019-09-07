import QtQuick 2.12
import QtQuick.Controls 2.12

Item {
    id:notify
    property bool showing: false
    width: 250
    height: showing? 80:0

    function hide(){
        showing = false
        pAnimation.stop()
        pBar.value = 0
    }
    function show(info){
        notifyText.text = info
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
    }

    Rectangle{
        id: background
        anchors.fill: parent
        color: "#3EC6AA"
        border.color: "white"
        border.width: 3
        radius: 2
        opacity: 0.8
        layer.enabled: true

        ScrollView{
            ScrollBar.vertical.policy: ScrollBar.AlwaysOn

            anchors{
                margins: 2
                left: parent.left
                right: closeBtn.left
                bottom: pBar.top
            }
            height: 60

            TextArea{
                id: notifyText
                text: ""
                color: "black"
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
                bottom: parent.bottom
                bottomMargin: 20
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
        onFinished: hide()
    }


}
