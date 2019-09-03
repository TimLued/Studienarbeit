import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Controls.Styles 1.4
import QtQuick.Window 2.12
import "algos.js" as Algos



Item{
    id: dronePanel
    property bool shown: true
    width: shown ? 150 : 0
    property variant colors: ["red","blue","green","purple","darkorange","darkred","fuchsia"]
    function noMark(){list.currentIndex = -1}

    anchors{
        top: parent.top
        bottom: parent.bottom
        left: parent.left
        leftMargin: 20
        topMargin: 20
        bottomMargin: 20
    }

    Behavior on width{
        PropertyAnimation{
            duration: 500
            easing.type: Easing.Linear
        }
    }

    Rectangle{
        id:panelBG
        anchors.fill: parent
        opacity: 0.8
        color: "#3EC6AA"
        MouseArea {
            hoverEnabled: true
            anchors.fill: parent
            onEntered: list.currentIndex = -1
        }
    }

    Rectangle{//Closer
        anchors{
            verticalCenter: parent.verticalCenter
            left: panelBG.right
        }
        width: 20
        height: 80
        color: panelBG.color
        Text{
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter
            horizontalAlignment: Text.AlignHCenter
            width: contentItem.implicitWidth
            font.pixelSize: 25
            font.bold: true
            text: shown? "\u25C1" : "\u25B7"

        }
        MouseArea{
            anchors.fill:parent
            onClicked: {shown = !shown}
        }
    }


    Component{
        id: listDelegate
        Item{
            id: listItem
            width: parent.width
            height: small

            Rectangle{
                //opacity: 0.5
                anchors.fill: parent
                color: "white"

                MouseArea {
                    hoverEnabled: true
                    anchors.fill: parent

                    onClicked: {
                        if(listItem.height === small){listItem.height = enlarged
                        }else{listItem.height = small}
                    }

                    onEntered: list.currentIndex = index
                }
            }

            Column{
                id: mainColumn
                spacing: 2
                layer.enabled: true

                anchors{
                    fill: parent
                    leftMargin: 10
                    rightMargin: 10
                    topMargin: 5
                    bottomMargin: 5
                }

                Row{
                    id: row0
                    Label{
                        id: lbl1
                        text: idInfo
                        color: if(visibleInfo) {colorInfo}else{"grey"}
                        font.pixelSize: txtSize
                        wrapMode: Text.WrapAnywhere
                        width: 150 -parent.anchors.leftMargin
                        renderType: Text.NativeRendering
                    }
                }



                Row{
                    id: row1
                    //visible: if(listItem.height === enlarged){true}else{false}
                    spacing: 2

                    Button{//History
                        id:historyBtn
                        highlighted: trackingHistoryInfo
                        enabled: listItem.height === enlarged ? true : false
                        onClicked:{
                            dronemodel.toggleHistoryTracking(idInfo)
                        }
                        contentItem: Text {
                            text: "History"
                            horizontalAlignment: Text.AlignHCenter
                            font.pixelSize: 12
                            color: historyBtn.down||historyBtn.highlighted ? "#3EC6AA" : "black" + historyBtn.leftPadding + historyBtn.rightPadding
                            elide: Text.ElideRight
                        }

                        background: Rectangle {
                            implicitWidth: contentItem.implicitWidth
                            implicitHeight: 20
                            border.color: historyBtn.down||historyBtn.highlighted ? "#3EC6AA" : "black"
                            border.width: 1
                            radius: 2
                        }

                    }

                    Button{//Route
                        id:routeBtn
                        highlighted: showingRouteInfo
                        enabled: listItem.height === enlarged ? true : false
                        onClicked:{
                            dronemodel.toggleShowingRoute(idInfo)
                        }

                        contentItem: Text {
                            text: "Route"
                            horizontalAlignment: Text.AlignHCenter
                            font.pixelSize: 12
                            color: routeBtn.down||routeBtn.highlighted ? "#3EC6AA" : "black"
                            elide: Text.ElideRight
                        }

                        background: Rectangle {
                            implicitWidth: contentItem.implicitWidth
                            height: historyBtn.height
                            border.color: routeBtn.down||routeBtn.highlighted ? "#3EC6AA" : "black"
                            border.width: 1
                            radius: 2
                        }
                    }

                }

                Row{
                    id: row2
                    spacing: 2

                    Button{//Edit Route
                        id: editBtn
                        enabled: listItem.height === enlarged ? true : false
                        onClicked:{
                            if(showingRouteInfo) dronemodel.toggleShowingRoute(idInfo)
                            wpModel.clear()
                            for (var i = 0;i<wpInfo.length;i++){
                                wpModel.append({"name":wpInfo[i].id,"lat":wpInfo[i].lat,"lon":wpInfo[i].lon})
                            }
                            onMapWpModel.update()

                            wpPanel.droneId = idInfo
                            wpPanel.show()
                        }
                        contentItem: Text {
                            font.pixelSize: 12
                            text: "\u26ED"
                            horizontalAlignment: Text.AlignHCenter
                            color: editBtn.down||editBtn.highlighted ? "#3EC6AA" : "black"
                            elide: Text.ElideRight
                        }

                        background: Rectangle {
                            width: contentItem.implicitWidth
                            height: historyBtn.height
                            border.color: (editBtn.down||editBtn.highlighted)? "#3EC6AA" : "black"
                            border.width: 1
                            radius: 2
                        }
                    }

                    Button{//Follow
                        id: followBtn
                        highlighted: followInfo

                        enabled: listItem.height === enlarged ? true : false

                        onClicked:{
                            if (!map.isCenterOnAll) {
                                dronemodel.toggleFollow(idInfo)
//                                if (!followInfo) map.bearing=0
                            }
                        }
                        contentItem: Text {
                            font.pixelSize: 12
                            text: "\u29BF"
                            horizontalAlignment: Text.AlignHCenter
                            color: followBtn.down||followBtn.highlighted ? "#3EC6AA" : "black"
                            elide: Text.ElideRight
                        }

                        background: Rectangle {
                            implicitWidth: contentItem.implicitWidth
                            height: historyBtn.height
                            border.color: (followBtn.down||followBtn.highlighted)? "#3EC6AA" : "black"
                            border.width: 1
                            radius: 2
                        }
                    }

                    Button{//Visible
                        id: visibleBtn
                        highlighted: !visibleInfo
                        enabled: listItem.height === enlarged ? true : false
                        onClicked:{
                            if (visibleInfo) {dronemodel.setVisibility(idInfo,false)}else{dronemodel.setVisibility(idInfo,true)}
                        }
                        contentItem: Text {
                            text: "\u20E0"
                            horizontalAlignment: Text.AlignHCenter
                            font.pixelSize: 12
                            color: visibleBtn.down||visibleBtn.highlighted ? "#FF5733" : "black"
                            elide: Text.ElideRight
                        }

                        background: Rectangle {
                            implicitWidth: contentItem.implicitWidth + visibleBtn.leftPadding + visibleBtn.rightPadding
                            height: historyBtn.height
                            border.color: visibleBtn.down||visibleBtn.highlighted ? "#FF5733" : "black"
                            border.width: 1
                            radius: 2
                        }
                    }

                    ComboBox{
                        id: cbColor
                        enabled: listItem.height === enlarged ? true : false

                        background: Rectangle{
                            id: cbBG
                            implicitWidth: 30
                            implicitHeight: historyBtn.implicitHeight
                            radius: 2
                            border.width: 1
                        }

                        delegate: ItemDelegate {
                            contentItem: Rectangle {
                                anchors.fill: parent
                                color: modelData
                            }
                        }

                        indicator: Canvas {}
                        contentItem: Text {}


                        property bool initial:false

                        model: ListModel{id: colorModel}

                        Component.onCompleted: {
                            for (var k = 0;k<colors.length;k++){
                                colorModel.append(({"color": colors[k]}))
                            }
                            currentIndex = find(colorInfo)
                            cbBG.color = colorInfo
                            initial = true
                        }
                        onCurrentIndexChanged: {
                            if (initial){
                                dronemodel.setColor(idInfo,colorModel.get(currentIndex).color)
                                cbBG.color = colorModel.get(currentIndex).color
                            }
                        }

                    }

                }

                Row{
                    id: row3
                    spacing: 2

                    ComboBox{ //available data to display
                        id: dataCB
                        enabled: listItem.height === enlarged ? true : false
                        font.pixelSize: 10
                        model: infoNamesInfo

                        background: Rectangle {
                            implicitWidth: 80
                            height: historyBtn.height
                            border.color: dataCB.pressed ? "#3EC6AA" : "black"
                            radius: 2
                            border.width: 1
                        }

                    }

                    Button{// add info displayed
                        id:plusBtn
                        onClicked: {
                            if (dataCB.currentIndex!=-1) dronemodel.setSelectedInfoList(idInfo,dataCB.currentText)
                        }
                        contentItem: Text {
                            text: "+"
                            horizontalAlignment: Text.AlignHCenter
                            color: plusBtn.down ? "#3EC6AA" : "black"
                            elide: Text.ElideRight
                        }

                        background: Rectangle {
                            implicitWidth: contentItem.implicitWidth+plusBtn.leftPadding+plusBtn.rightPadding
                            implicitHeight: historyBtn.height
                            border.color: plusBtn.down ? "#3EC6AA" : "black"
                            border.width: 1
                            radius: 2
                        }
                    }

                    Button{// delete info displayed
                        id:minusBtn
                        onClicked: {
                            if (dataCB.currentIndex!=-1) dronemodel.setUnselectedInfoList(idInfo,dataCB.currentText)
                        }
                        contentItem: Text {
                            text: "-"
                            horizontalAlignment: Text.AlignHCenter
                            color: minusBtn.down ? "#3EC6AA" : "black"
                            elide: Text.ElideRight
                        }

                        background: Rectangle {
                            implicitWidth: contentItem.implicitWidth+minusBtn.leftPadding+minusBtn.rightPadding
                            implicitHeight: historyBtn.height
                            border.color: minusBtn.down ? "#3EC6AA" : "black"
                            border.width: 1
                            radius: 2
                        }
                    }

                }


                Flickable  {
                    id: fparent
                    height: parent.height - row0.height- row1.height- row2.height- row3.height -4*2
                    width: 150
                    interactive: true
                    clip: true
                    flickableDirection: Flickable.VerticalFlick
                    contentHeight: dataLV.height

                    ListView{
                        id: dataLV
                        width: fparent.width - 2
                        height: childrenRect.height
                        clip: true
                        interactive: false
                        spacing: 3
                        model: infoSelectedNamesRole

                        delegate: Text{
                            text: "<b>" + infoSelectedNamesRole[index] + "</b>: " + InfoSelectedValuesRole[index]
                            wrapMode: Text.WrapAnywhere
                            width: dataLV.width
                            renderType: Text.NativeRendering
                        }

                        onCountChanged: {
                            fparent.returnToBounds();
                        }

                    }
                }

            }
        }
    }

    //Highlight on hover
    Component{
        id: mark
        Rectangle {
            opacity: 0.4
            color: "grey"
            visible: (list.currentIndex  !== -1)
        }
    }

    ListView{
        id: list
        anchors.fill: parent
        clip:true
        model: dronemodel
        delegate: listDelegate
        //highlight: mark
        highlightFollowsCurrentItem: true
        highlightMoveVelocity: -1
        highlightResizeVelocity: -1
        Component.onCompleted: currentIndex = -1
        spacing: 2
    }


}
