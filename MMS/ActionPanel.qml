import QtQuick 2.12
import QtQuick.Controls 2.5
import "algos.js" as Algos
import QtPositioning 5.12

Item {
    id: actionPanel
    width: 50

    anchors{
        right: parent.right
        bottom: map.bottom
        top: map.top
        rightMargin: 5
    }

//    Rectangle{
//        id: actionBG
//        anchors.centerIn: parent
//        width: parent.width
//        height: 300
//        color: "white"
//    }

    Column{
        anchors.verticalCenter: parent.verticalCenter

        //leftPadding: 5
        //topPadding: actionBG.height/2-btnSize*4/2

        spacing: 20
        RoundButton{
            text: "X"
            radius: btnSize / 2
            font.pixelSize: txtSize
            palette {button: "#3EC6AA"}
        }
        RoundButton {
            text: "\u25EF"
            radius: btnSize / 2
            font.pixelSize: txtSize
            palette {button: "#3EC6AA"}
            highlighted: map.circleRulerVisible
            onClicked: {
                map.circleRulerVisible = !map.circleRulerVisible
            }
        }
        RoundButton{
            text: "\u29BF"
            radius: btnSize / 2
            font.pixelSize: txtSize
            palette {button: "#3EC6AA"}
            highlighted: map.isCenterOnAll
            onClicked: {
                map.isCenterOnAll = !map.isCenterOnAll

            }
        }

    }

}
