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

    Column{
        anchors.verticalCenter: parent.verticalCenter

        //leftPadding: 5
        //topPadding: actionBG.height/2-btnSize*4/2

        spacing: 20
        RoundButton{
            text: "X"
            radius: btnSize / 2
            width: btnSize
            font.pixelSize: txtSize
            palette {button: "#3EC6AA"}
        }

        Row{

            LayoutMirroring.enabled: true
            anchors.left: parent.left
            anchors.leftMargin: map.circleRulerVisible? btnSize/2 : 0

            RoundButton {
                text: "\u25EF"
                width: btnSize
                radius: btnSize / 2
                font.pixelSize: txtSize
                palette {button: "#3EC6AA"}
                highlighted: map.circleRulerVisible
                onClicked: {
                    map.circleRulerVisible = !map.circleRulerVisible
                    if (!map.circleRulerVisible) {
                        zoomOffset=0
                        win.setCircleScale(zoomOffset)
                    }
                }
            }

            Column{
                spacing: 2
                RoundButton {
                    text: "+"
                    visible: map.circleRulerVisible
                    width: btnSize / 2 - 1
                    height: width
                    radius: width / 2
                    font.pixelSize: txtSize
                    palette {button: "#3EC6AA"}
                    onClicked: {
                        zoomOffset +=1
                        win.setCircleScale(zoomOffset)
                    }
                }
                RoundButton {
                    text: "-"
                    visible: map.circleRulerVisible
                    width: btnSize / 2 - 1
                    height: width
                    radius: width / 2
                    font.pixelSize: txtSize
                    palette {button: "#3EC6AA"}
                    onClicked: {
                        zoomOffset -=1
                        win.setCircleScale(zoomOffset)
                    }
                }
            }



        }

        RoundButton{
            text: "\u29BF"
            width: btnSize
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
