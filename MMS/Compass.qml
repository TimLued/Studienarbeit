import QtQuick 2.0

Item {
    width:txt.width
    height:txt.height

    anchors{

    }

    Text{
        id: txt
        text: "\u29BD"
        font.pixelSize: 25
        color: "3EC6AA"
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        width: contentItem.implicitWidth
        height: contentItem.implicitHeight
    }


}
