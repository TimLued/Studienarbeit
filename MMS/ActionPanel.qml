import QtQuick 2.12
import QtQuick.Controls 2.5

Item {
    id: actionPanel
    width: 50


    anchors{
        right: parent.right
        bottom: map.bottom
        top: map.top
        rightMargin: 5
    }

    Rectangle{
        id: actionBG
        anchors.centerIn: parent
        width: parent.width
        height: 300
        opacity: 0.7
        color: "Grey"
        radius: 10
    }

    Column{
        anchors.fill: actionBG
        leftPadding: 5
        topPadding: actionBG.height/2-btnSize*4/2

        spacing: 20
        Button{
            text: "X"
            height: btnSize
            width: btnSize
            font.pixelSize: txtSize
        }
        RoundButton {
            text: "X"
            radius: btnSize / 2
            font.pixelSize: txtSize
        }
        Button{
            text: "X"
            height: btnSize
            width: btnSize
            font.pixelSize: txtSize
        }

    }

}
