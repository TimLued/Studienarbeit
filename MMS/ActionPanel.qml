import QtQuick 2.12
import QtQuick.Controls 2.5
import "algos.js" as Algos
import QtPositioning 5.12

Item {
    id: actionPanel
    width: 50
    opacity: 0.7

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
        color: "white"
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
            text: "O"
            height: btnSize
            width: btnSize
            font.pixelSize: txtSize
            highlighted: map.isCenterOnAll

            onClicked: {
                map.isCenterOnAll = !map.isCenterOnAll

            }
        }

    }

}
