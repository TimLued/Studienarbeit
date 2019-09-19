import QtQuick 2.12
import QtQuick.Controls 2.5
import "algos.js" as Algos
import QtPositioning 5.12

Item {
    id: actionPanel
    width: 50
    property int noticationCount: 0
    function show(){actionPanel.visible = true}
    function hide(){actionPanel.visible = false}

    anchors{
        right: parent.right
        bottom: parent.bottom
        top: parent.top
        rightMargin: 5
    }

    Column{
        anchors.verticalCenter: parent.verticalCenter

        spacing: 20

        RoundButton{
            text: noticationCount
            radius: btnSize / 2
            width: btnSize
            height: btnSize
            font.pixelSize: 16
            palette {button: noticationCount>0?"#ff9e17":"#3EC6AA"}
            onClicked: {
                if (noticationCount>0) notifyPanel.showNow()}
        }

        RoundButton{
            text: "\u25A7"
            radius: btnSize / 2
            width: btnSize
            height: btnSize
            font.pixelSize: 30
            palette {button: "#3EC6AA"}
            onClicked: missionPanel.show(false)
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

        RoundButton{
            text: "\u2600"
            width: btnSize
            radius: btnSize / 2
            font.pixelSize: txtSize
            palette {button: "#3EC6AA"}
            checkable: true
            onClicked: {
                map.activeMapType =  map.supportedMapTypes[checked?1:0]
            }
        }

        RoundButton{
            text: "\u20E0"
            width: btnSize
            radius: btnSize / 2
            font.pixelSize: txtSize
            palette {button: "#3EC6AA"}
            onClicked: {
                dronePanel.shown = false
                notifyPanel.hide()
                wpPanel.hide()
                missionPanel.hide
            }
        }


    }

}
