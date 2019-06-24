import QtQuick 2.12
import QtPositioning 5.12
import QtLocation 5.12

MapQuickItem {
    id: popup
    visible: false

    property string droneId
    property string droneColor: "black"
    property int tSize: 12

    function setModel(droneModel){
        dataLV.model = droneModel
    }

    function clearModel() {dataLV.model = []}

    //STILL: update model



    sourceItem: Item{
        width: 100
        height: 100

        Rectangle{
            anchors.fill: parent
            color: "white"
            opacity: 0.8
        }

        Column{
            anchors.fill: parent
            anchors.margins: 5
            spacing: 4
            layer.enabled: true

            Text{text: droneId; font.bold: true; font.pixelSize: tSize; color: droneColor}

            Flickable {
                id: fparent
                height:70
                width: parent.width

                interactive: true
                clip: true
                flickableDirection: Flickable.VerticalFlick
                contentHeight: dataLV.height

                ListView{
                    id: dataLV
                    width: fparent.width
                    height: childrenRect.height
                    clip: true
                    interactive: false
                    spacing: 2

                    delegate: Text{
                        text: dataLV.model[index].name + ": " + dataLV.model[index].value
                        wrapMode: Text.WordWrap
                        width: dataLV.width
                    }

                    onCountChanged: {
                        fparent.returnToBounds();
                    }
                }
            }
        }




    }

    anchorPoint.x: -10
    anchorPoint.y: -10


}
