import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Styles 1.4
import QtQuick.Window 2.12
import "algos.js" as Algos


Item{
    id: dronePanel
    property bool shown: true
    property variant colors: ["red","blue","green","purple","darkorange","darkred","fuchsia"]
    property string addingToGroup

    width: shown ? 150 : 0
    Behavior on width{
        PropertyAnimation{
            duration: 500
            easing.type: Easing.Linear
        }
    }

    anchors{
        top: parent.top
        bottom: parent.bottom
        left: parent.left
        leftMargin: 20
        topMargin: 20
        bottomMargin: 20
    }


    Rectangle{//Closer
        z:10
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

    Rectangle{
        id:panelBG
        anchors.fill: parent
        opacity: 0.8
        color: "#3EC6AA"
        layer.enabled: true
        property bool uavExtended: true
        property bool groupExtended: true

        ScrollView{
            ScrollBar.vertical.policy: ScrollBar.AlwaysOff
            anchors{
                top: parent.top
                bottom: parent.bottom
                left: parent.left
            }
            width: panelBG.width
            contentHeight: frame.height

            Rectangle{
                id: frame
                color:"transparent"
                height: childrenRect.height+10
                anchors{
                    top:parent.top
                    left:parent.left
                    right:parent.right
                }


                Rectangle{
                    id: dronesHeader

                    property int space: 10
                    width: parent.width
                    height: extendBtn.height
                    anchors{
                        left: parent.left
                        top: parent.top
                        topMargin: 4
                    }
                    color:"transparent"

                    Rectangle{
                        id: extendBtn
                        anchors{
                            right: parent.right
                            verticalCenter: parent.verticalCenter
                            rightMargin: 4
                        }
                        width: 20
                        height: 20
                        border.color: "white"
                        border.width: 1
                        color: "transparent"
                        radius: 2

                        MouseArea{
                            anchors.fill:parent
                            onClicked: {
                                panelBG.uavExtended = !panelBG.uavExtended
                            }
                        }
                        Text {
                            width:parent.width
                            height:parent.height
                            y:-1
                            text: panelBG.uavExtended? "-":"+"
                            font.pixelSize: 16
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                            color: "black"
                            elide: Text.ElideRight
                        }
                    }

                    Text{
                        id:headerText
                        text: "UAV"
                        font.pixelSize: 12
                        color:"white"
                        anchors{
                            left: parent.left
                            right: parent.right
                            verticalCenter: parent.verticalCenter
                        }
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                    Rectangle{
                        id: leftLine
                        height: 1
                        width: parent.width / 2 - Algos.calcTxtWidth(headerText.text,headerText) / 2 - parent.space
                        color:"white"
                        anchors{
                            left: parent.left
                            verticalCenter: parent.verticalCenter
                        }
                    }
                    Rectangle{
                        height: 1
                        width: leftLine.width-extendBtn.width - extendBtn.anchors.rightMargin
                        color:"white"
                        anchors{
                            right: extendBtn.left
                            verticalCenter: parent.verticalCenter
                        }
                    }
                }

                Rectangle{
                    id: uavContainer
                    layer.enabled: true
                    color:"transparent"
                    anchors{
                        top: dronesHeader.bottom
                        left:parent.left
                        right:parent.right
                        topMargin: 4
                    }
                    height: panelBG.uavExtended? droneLV.contentHeight:0

                    Behavior on height{
                        PropertyAnimation{
                            duration: 200
                            easing.type: Easing.Linear
                        }
                    }

                    ListView{
                        id: droneLV
                        anchors.fill: parent
                        clip:true
                        model: dronemodel
                        delegate: droneLvDelegate
                        spacing: 2
                    }
                }


                Rectangle{
                    id: groupHeader

                    property int space: 10
                    width: parent.width
                    height: extendGroupBtn.height
                    anchors{
                        left: parent.left
                        top: uavContainer.bottom
                        topMargin: 4
                    }
                    color:"transparent"



                    Rectangle{
                        id: extendGroupBtn
                        anchors{
                            right: parent.right
                            verticalCenter: parent.verticalCenter
                            rightMargin: 4
                        }
                        width: 20
                        height: 20
                        border.color: "white"
                        border.width: 1
                        color: "transparent"
                        radius: 2

                        MouseArea{
                            anchors.fill:parent
                            onClicked: {
                                panelBG.groupExtended = !panelBG.groupExtended
                            }
                        }
                        Text {
                            width:parent.width
                            height:parent.height
                            y:-1
                            text: panelBG.groupExtended? "-":"+"
                            font.pixelSize: 16
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                            color: "black"
                            elide: Text.ElideRight
                        }
                    }

                    Text{
                        id:headerGroupText
                        text: "Groups"
                        font.pixelSize: 12
                        color:"white"
                        anchors{
                            left: parent.left
                            right: parent.right
                            verticalCenter: parent.verticalCenter
                        }
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                    Rectangle{
                        id: leftGroupLine
                        height: 1
                        width: parent.width / 2 - Algos.calcTxtWidth(headerGroupText.text,headerGroupText) / 2 - parent.space
                        color:"white"
                        anchors{
                            left: parent.left
                            verticalCenter: parent.verticalCenter
                        }
                    }
                    Rectangle{
                        height: 1
                        width: leftGroupLine.width-extendGroupBtn.width - extendGroupBtn.anchors.rightMargin
                        color:"white"
                        anchors{
                            right: extendGroupBtn.left
                            verticalCenter: parent.verticalCenter
                        }
                    }
                }


                Rectangle{
                    id: groupContainer
                    layer.enabled: true
                    color:"transparent"
                    anchors{
                        top: groupHeader.bottom
                        left:parent.left
                        right:parent.right
                        topMargin: 4
                    }
                    height: panelBG.groupExtended? groupLV.contentHeight+addBtnContainer.height:0

                    Behavior on height{
                        PropertyAnimation{
                            duration: 200
                            easing.type: Easing.Linear
                        }
                    }


                    Rectangle{
                        id:groupLvContainer
                        color:"transparent"
                        anchors{
                            left: parent.left
                            right: parent.right
                            top: parent.top
                        }
                        height: parent.height - addBtnContainer.height

                        ListView{
                            id: groupLV
                            anchors.fill: parent
                            clip:true
                            model: groupmodel

                            delegate: groupLvDelegate
                            spacing: 2
                        }
                    }


                    Rectangle{
                        id: addBtnContainer
                        color:"transparent"
                        anchors{
                            left:parent.left
                            right:parent.right
                            top:groupLvContainer.bottom
                        }
                        height: addGroupBtn.height + addGroupBtn.anchors.topMargin

                        Rectangle{
                            id: addGroupBtn
                            width: 40
                            anchors{
                                horizontalCenter: parent.horizontalCenter
                                top: parent.top
                                topMargin: 3
                            }
                            MouseArea{
                                anchors.fill:parent
                                onClicked: groupmodel.createGroup()
                            }
                            height: 20
                            border.color: addGroupText.color
                            border.width: 1
                            color: "transparent"
                            Text {
                                id:addGroupText
                                text: "+"
                                width:parent.width
                                height:parent.height
                                font.pixelSize: 16
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                                y:-1
                                color: "white"
                                elide: Text.ElideRight
                            }
                        }
                    }

                }
            }
        }
    }



    Component{
        id: groupLvDelegate
        Item{
            id: groupItem
            width: 150
            height: small
            Rectangle{
                anchors.fill: parent
                color: "white"
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        if(missionPanel.addingDrones){
                            for(var i=0;i<memberInfo.length;i++){
                                missionPanel.addDrone(memberInfo[i])
                            }
                        }else{
                            if(groupItem.height === small){groupItem.height = 180
                            }else{groupItem.height = small}
                        }
                    }
                }
            }
            Rectangle{
                id: groupHeader
                anchors{
                    left: parent.left
                    right: parent.right
                    top: parent.top
                }
                height: small

                Text{
                    id: groupName
                    anchors{
                        left: parent.left
                        top: parent.top
                        right: groupNameEditBtn.left
                        bottom: parent.bottom
                        leftMargin: 10
                    }
                    width: 150 - anchors.leftMargin
                    verticalAlignment: Text.AlignVCenter
                    text: idInfo
                    color: visibleInfo? colorInfo:"grey"
                    font.pixelSize: txtSize
                    wrapMode: Text.WrapAnywhere
                    renderType: Text.NativeRendering
                }

                TextField{
                    id: groupTextField
                    anchors.fill: groupName
                    leftPadding: 0
                    font.pixelSize: txtSize
                    visible: groupNameEditBtn.checked
                    text: groupName.text
                    font.italic: true
                    selectByMouse: true
                    background: Rectangle {border.width: 0}
                    onVisibleChanged: {
                        if (!groupTextField.visible&&groupTextField.text!=idInfo){
                            groupmodel.setGroupId(idInfo,groupTextField.text)
                        }
                    }
                }

                Rectangle{
                    id: groupNameEditBtn
                    property bool checked: false
                    visible: groupItem.height != small
                    anchors{
                        right: parent.right
                        verticalCenter: groupName.verticalCenter
                        margins: 5
                    }
                    width: 20
                    height: 20
                    radius: width / 2
                    border.color: groupNameEditText.color
                    border.width: 1
                    color: "transparent"
                    Text {
                        id:groupNameEditText
                        text: "\u26ED"
                        anchors.fill:parent
                        font.pixelSize: 14
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        color: parent.checked? "#3EC6AA":"grey"
                        elide: Text.ElideRight
                    }
                    MouseArea{
                        anchors.fill:parent
                        onClicked: {
                            parent.checked = !parent.checked
                            groupTextField.text = groupName.text
                        }
                    }
                }

            }

            Column{
                spacing: 3
                layer.enabled: true

                anchors{
                    top: groupHeader.bottom
                    bottom: parent.bottom
                    left: parent.left
                    right: parent.right
                    leftMargin: 10
                    rightMargin: 10
                    bottomMargin: 5
                }

                Row{
                    id: groupBtnRow
                    spacing: 2


                    Rectangle{
                        id: followGroupBtn
                        width: Algos.calcTxtWidth(followGroupText.text,followGroupText) + 10

                        MouseArea{
                            anchors.fill:parent
                            enabled: groupItem.height !=small
                            onClicked: {
                                //set group following, reset other groups
                                groupmodel.setFollow(idInfo,!followInfo)
                                if(followInfo)
                                    map.groupfollow = idInfo
                                else map.groupfollow = ""
                            }
                        }
                        height: 20
                        border.color: followGroupText.color
                        border.width: 1
                        color: "transparent"
                        Text {
                            id:followGroupText
                            text: "\u2B9D"
                            anchors.fill:parent
                            font.pixelSize: 12
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                            color: followInfo? "#3EC6AA" : "black"
                            elide: Text.ElideRight
                        }
                    }




                    Rectangle{
                        id: centerGroupBtn
                        width: Algos.calcTxtWidth(centerGroupText.text,centerGroupText) + 10

                        MouseArea{
                            anchors.fill:parent
                            enabled: groupItem.height !=small
                            onClicked: {
                                if (!map.isCenterOnAll) {
                                    var positions = []
                                    for(var i=0;i<memberInfo.length;i++){
                                        positions.push(dronemodel.getDronePos(memberInfo[i]))
                                    }
                                    var region = centerMapRegion(positions)
                                    if(region) map.fitViewportToGeoShape(region,200)
                                }
                            }
                        }
                        height: 20
                        border.color: centerGroupText.color
                        border.width: 1
                        color: "transparent"
                        Text {
                            id:centerGroupText
                            text: "\u29BF"
                            anchors.fill:parent
                            font.pixelSize: 12
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                            color: "black"
                            elide: Text.ElideRight
                        }
                    }

                    Rectangle{
                        id: visibleGroupBtn
                        width: Algos.calcTxtWidth(visibleGroupText.text,visibleGroupText) + 15

                        MouseArea{
                            anchors.fill:parent
                            enabled: groupItem.height !=small
                            onClicked: {
                                groupmodel.setVisibility(idInfo,!visibleInfo)
                                for(var i=0;i<memberInfo.length;i++){
                                    dronemodel.setVisibility(memberInfo[i],visibleInfo)
                                }
                            }
                        }
                        height: 20
                        border.color: visibleGroupText.color
                        border.width: 1
                        color: "transparent"
                        Text {
                            id:visibleGroupText
                            text: "\u20E0"
                            anchors.fill:parent
                            font.pixelSize: 12
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                            color: !visibleInfo? "#FF5733" : "black"
                            elide: Text.ElideRight
                        }
                    }


                    ComboBox{
                        id: cbGroubColor

                        background: Rectangle{
                            id: cbGroupBG
                            implicitWidth: 30
                            implicitHeight: 20
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
                            cbGroupBG.color = colorInfo
                            initial = true
                        }
                        onCurrentIndexChanged: {
                            if (initial){
                                var color = colorModel.get(currentIndex).color
                                groupmodel.setGroupColor(idInfo,color)
                                cbGroupBG.color = color
                                for(var i=0;i<memberInfo.length;i++){
                                    dronemodel.setGroup(memberInfo[i],color)
                                }
                            }
                        }

                    }
                }

                Text{
                    anchors{
                        left: parent.left
                        right:parent.right
                    }
                    text:"Drohnen:"
                    font.bold:true
                }

                Flickable  {
                    id:groupFlickable
                    height: contentHeight<50?contentHeight:50
                    width: 130
                    interactive: true
                    clip: true
                    flickableDirection: Flickable.VerticalFlick
                    contentHeight: groupMembersLV.height
                    ScrollBar.vertical: ScrollBar {
                    policy: (groupFlickable.contentHeight>groupFlickable.height)?ScrollBar.AlwaysOn:ScrollBar.AlwaysOff
                    }

                    ListView{
                        id: groupMembersLV
                        width: parent.width
                        height: childrenRect.height
                        clip: true
                        interactive: false
                        spacing: 1
                        model: memberInfo

                        delegate: Component{
                            Item{
                                id: groupItem
                                width: parent.width
                                height: memberText.height

                                Text{
                                    id: memberText
                                    text: memberInfo[index]
                                    wrapMode: Text.WrapAnywhere
                                    width: parent.width
                                    renderType: Text.NativeRendering
                                }

                                Text{
                                    text: "X"
                                    color: "#FF5733"
                                    anchors{
                                        right: parent.right
                                        verticalCenter: parent.verticalCenter
                                        rightMargin: 20
                                    }
                                    height: parent.height
                                    verticalAlignment: Text.AlignVCenter
                                    MouseArea{
                                        enabled: groupItem.height !=small
                                        anchors.fill:parent
                                        onClicked: {
                                            var drone = memberInfo[index]
                                            dronemodel.setGroup(drone,"")
                                            groupmodel.removeMember(idInfo,drone)
                                        }
                                    }
                                }
                            }
                        }
                        onCountChanged: groupFlickable.returnToBounds();
                    }
                }



                Rectangle{
                    property bool checked: false
                    width: Algos.calcTxtWidth(addDroneToGroupText.text,addDroneToGroupText) + 5
                    MouseArea{
                        enabled: groupItem.height !=small
                        anchors.fill:parent
                        onClicked:{
                            parent.checked = !parent.checked
                            if(parent.checked)
                                addingToGroup = idInfo
                            else
                                addingToGroup = ""
                        }
                    }
                    height: 20
                    border.color: addDroneToGroupText.color
                    border.width: 1
                    color: "transparent"
                    Text {
                        id:addDroneToGroupText
                        text: "Drohne hinzufügen"
                        leftPadding: 2
                        anchors.fill:parent
                        font.pixelSize: 12
                        verticalAlignment: Text.AlignVCenter
                        color: parent.checked? "#3EC6AA":"black"
                        elide: Text.ElideRight
                    }
                }
                Rectangle{
                    width: Algos.calcTxtWidth(delGroupText.text,delGroupText) + 5
                    MouseArea{
                        anchors.fill:parent
                        enabled: groupItem.height !=small
                        onClicked: {
                            for(var i=0;i<memberInfo.length;i++){
                                dronemodel.setGroup(memberInfo[i],"")
                            }
                            groupmodel.deleteGroup(idInfo)
                        }
                    }
                    height: 20
                    border.color: delGroupText.color
                    border.width: 1
                    color: "transparent"
                    Text {
                        id:delGroupText
                        text: "Gruppe auflösen"
                        anchors.fill:parent
                        leftPadding: 2
                        font.pixelSize: 12
                        verticalAlignment: Text.AlignVCenter
                        color: "#FF5733"
                        elide: Text.ElideRight
                    }
                }

            }
        }
    }



    Component{
        id: droneLvDelegate
        Item{
            id: droneItem
            width: parent.width
            height: small
            opacity: 1

            Rectangle{
                anchors.fill: parent
                color: "white"

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        if (addingToGroup !=""){
                            groupmodel.addMember(addingToGroup,idInfo)
                            var groupColor = groupmodel.getGroupColor(addingToGroup)
                            dronemodel.setGroup(idInfo,groupColor)
                        }else if(missionPanel.addingDrones){
                            missionPanel.addDrone(idInfo)
                        }else{
                            if(droneItem.height === small){droneItem.height = 195
                            }else{droneItem.height = small}
                        }
                    }
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
                    spacing: 1
                    Text{
                        id: lbl1
                        text: idInfo
                        font.letterSpacing: 1
                        color: if(visibleInfo) {groupInfo!=""? groupInfo:colorInfo}else{"grey"}
                        font.pixelSize: txtSize
                        wrapMode: Text.WrapAnywhere
                        width:parent.parent.width

                        renderType: Text.NativeRendering
                        onColorChanged: cbBG.color = color
                    }
                }

                Row{
                    id: row1
                    spacing: 2

                    Rectangle{
                        id: historyBtn
                        width: Algos.calcTxtWidth(historyText.text,historyText) + 5

                        MouseArea{
                            anchors.fill:parent
                            enabled: droneItem.height !=small
                            onClicked: {
                                dronemodel.toggleHistoryTracking(idInfo)
                            }
                        }
                        height: 20
                        border.color: historyText.color
                        border.width: 1
                        color: "transparent"
                        Text {
                            id:historyText
                            text: "History"
                            width:parent.width
                            height:parent.height
                            font.pixelSize: 12
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                            color: trackingHistoryInfo? "#3EC6AA" : "black"
                            elide: Text.ElideRight
                        }
                    }

                    Rectangle{
                        id: routeBtn
                        width: Algos.calcTxtWidth(routeText.text,routeText) + 5

                        MouseArea{
                            anchors.fill:parent
                            enabled: droneItem.height !=small && wpInfo.length>0
                            onClicked: {
                                dronemodel.toggleShowingRoute(idInfo)
                            }
                        }
                        height: 20
                        border.color: routeText.color
                        border.width: 1
                        color: "transparent"
                        Text {
                            id:routeText
                            text: "Route"
                            width:parent.width
                            height:parent.height
                            font.pixelSize: 12
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                            color: showingRouteInfo? "#3EC6AA" : (wpInfo.length>0?"black":"grey")
                            elide: Text.ElideRight
                        }
                    }

                    Rectangle{
                        id: mssionBtn
                        width: Algos.calcTxtWidth(missionText.text,missionText) + 5

                        MouseArea{
                            anchors.fill:parent
                            enabled: droneItem.height !=small
                            onClicked: {
                                missionPanel.show(true)
                            }
                        }
                        height: 20
                        border.color: "black"
                        border.width: 1
                        color: "transparent"
                        Text {
                            id:missionText
                            text: "Mission"
                            width:parent.width
                            height:parent.height
                            font.pixelSize: 12
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                            color: parent.border.color
                            elide: Text.ElideRight
                        }
                    }
                }

                Row{
                    id: row1_2
                    spacing: 1

                    Rectangle{
                        color:"transparent"
                        width:mainColumn.width
                        height:trackingHistoryInfo? timeSlider.height+rangeText.height+5:0
                        layer.enabled: true
                        Behavior on height{
                            PropertyAnimation{
                                duration: 200
                                easing.type: Easing.Linear
                            }
                        }
                        onHeightChanged:if(height!=0) timeSlider.reset()

                        Column{
                            spacing: 1

                            TimeSlider{
                                id:timeSlider
                                property int lockVal
                                width:mainColumn.width

                                enabled:trackingHistoryInfo

                                function reset(){
                                    //0-now
                                    dronemodel.setHistoryRange(idInfo,0,-2)
                                    lockVal = timestampsInfo.length-1
                                    first.value = 0
                                    second.value = lockVal
                                    rangeText.toVal = "now"
                                    rangeText.fromVal=Qt.formatDateTime(timestampsInfo[0],"hh:mm:ss")

                                }

                                to: lockVal

                                second.onMoved: {
                                    rangeText.toVal=second.value==lockVal? "now":Qt.formatDateTime(timestampsInfo[Math.round(second.value)],"hh:mm:ss")
                                }
                                first.onMoved: {
                                    rangeText.fromVal=Qt.formatDateTime(timestampsInfo[Math.round(first.value)],"hh:mm:ss")
                                }

                                first.onPressedChanged: {
                                    if(first.pressed){
                                        lockVal = timestampsInfo.length-1
                                        setValues(first.value,second.value)//update position
                                    }else{
                                        //set history left index
                                        dronemodel.setHistoryRange(idInfo,first.value,-1)
                                        //draw anew
                                    }
                                }

                                second.onPressedChanged: {
                                    if(second.pressed)
                                        lockVal = timestampsInfo.length-1
                                    else{
                                        //set history right index
                                        //-2 for latest position
                                        //-1 for no changes
                                        dronemodel.setHistoryRange(idInfo,-1,second.value==lockVal?-2:second.value)

                                    }
                                }
                            }

                            Text{
                                id:rangeText
                                enabled:trackingHistoryInfo
                                width:mainColumn.width
                                horizontalAlignment: Text.AlignHCenter
                                property string fromVal
                                property string toVal
                                text: fromVal + " - " + toVal
                            }
                        }
                    }
                }

                Row{
                    id: row2
                    spacing: 2

                    Rectangle{
                        id: editBtn
                        width: Algos.calcTxtWidth(editText.text,editText) + 10

                        MouseArea{
                            anchors.fill:parent
                            enabled: droneItem.height !=small
                            onClicked: {
                                if(showingRouteInfo) dronemodel.toggleShowingRoute(idInfo)
                                wpModel.clear()
                                for (var i = 0;i<wpInfo.length;i++){
                                    wpModel.append({"name":wpInfo[i].id,"lat":wpInfo[i].lat,"lon":wpInfo[i].lon})
                                }
                                onMapWpModel.update()

                                wpPanel.droneId = idInfo
                                wpPanel.show()
                            }
                        }
                        height: 20
                        border.color: editText.color
                        border.width: 1
                        color: "transparent"
                        Text {
                            id:editText
                            text: "\u26ED"
                            anchors.fill:parent
                            font.pixelSize: 12
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                            color: "black"
                            elide: Text.ElideRight
                        }
                    }


                    Rectangle{
                        id: followBtn
                        width: Algos.calcTxtWidth(followText.text,followText) + 10

                        MouseArea{
                            anchors.fill:parent
                            enabled: droneItem.height !=small
                            onClicked: {
                                dronemodel.toggleFollow(idInfo)
                            }
                        }
                        height: 20
                        border.color: followText.color
                        border.width: 1
                        color: "transparent"
                        Text {
                            id:followText
                            text: "\u2B9D"
                            anchors.fill:parent
                            font.pixelSize: 12
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                            color: followInfo? "#3EC6AA" : "black"
                            elide: Text.ElideRight
                        }
                    }

                    Rectangle{
                        id: centerBtn
                        width: Algos.calcTxtWidth(centerText.text,centerText) + 10

                        MouseArea{
                            anchors.fill:parent
                            enabled: droneItem.height !=small
                            onClicked: {
                                if (!map.isCenterOnAll) {
                                    var region = centerMapRegion([posInfo])
                                    map.fitViewportToGeoShape(region,200)
                                }
                            }
                        }
                        height: 20
                        border.color: centerText.color
                        border.width: 1
                        color: "transparent"
                        Text {
                            id:centerText
                            text: "\u29BF"
                            anchors.fill:parent
                            font.pixelSize: 12
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                            color: "black"
                            elide: Text.ElideRight
                        }
                    }

                    Rectangle{
                        id: visibleBtn
                        width: Algos.calcTxtWidth(visibleText.text,visibleText) + 15

                        MouseArea{
                            anchors.fill:parent
                            enabled: droneItem.height !=small
                            onClicked: {
                                if (visibleInfo) {dronemodel.setVisibility(idInfo,false)}else{dronemodel.setVisibility(idInfo,true)}
                            }
                        }
                        height: 20
                        border.color: visibleText.color
                        border.width: 1
                        color: "transparent"
                        Text {
                            id:visibleText
                            text: "\u20E0"
                            anchors.fill:parent
                            font.pixelSize: 12
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                            color: !visibleInfo? "#FF5733" : "black"
                            elide: Text.ElideRight
                        }
                    }


                    ComboBox{
                        id: cbColor

                        background: Rectangle{
                            id: cbBG
                            implicitWidth: 30
                            implicitHeight: historyBtn.height
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
                            if (initial&&groupInfo==""){
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

                        model: infoNamesInfo

                        indicator: Canvas {
                            id: canvas
                            x: dataCB.width - width - dataCB.rightPadding
                            y: dataCB.topPadding + (dataCB.availableHeight - height) / 2
                            width: 12
                            height: 8
                            contextType: "2d"

                            Connections {
                                target: dataCB
                                onPressedChanged: canvas.requestPaint()
                            }

                            onPaint: {
                                context.reset();
                                context.moveTo(0, 0);
                                context.lineTo(width, 0);
                                context.lineTo(width / 2, height);
                                context.closePath();
                                context.fillStyle = "grey";
                                context.fill();
                            }
                        }

                        contentItem: Text {
                            leftPadding: 5
                            rightPadding: dataCB.indicator.width + dataCB.spacing
                            text: dataCB.displayText
                            color: "BLACK"
                            verticalAlignment: Text.AlignVCenter
                            elide: Text.ElideRight
                        }

                        background: Rectangle {
                            implicitWidth: 80
                            implicitHeight: historyBtn.height
                            border.color: "black"
                            border.width: 1
                        }

                    }


                    Rectangle{
                        id: plusBtn
                        width: Algos.calcTxtWidth(plusText.text,plusText) + 10

                        MouseArea{
                            anchors.fill:parent
                            onClicked: {
                                if (dataCB.currentIndex!=-1) dronemodel.setSelectedInfoList(idInfo,dataCB.currentText)
                            }
                        }
                        height: 20
                        border.color: plusText.color
                        border.width: 1
                        color: "transparent"
                        Text {
                            id:plusText
                            text: "+"
                            anchors.fill:parent
                            font.pixelSize: 12
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                            color: "black"
                            elide: Text.ElideRight
                        }
                    }

                    Rectangle{
                        id: minusBtn
                        width: plusBtn.width

                        MouseArea{
                            anchors.fill:parent
                            onClicked: {
                                if (dataCB.currentIndex!=-1) dronemodel.setUnselectedInfoList(idInfo,dataCB.currentText)
                            }
                        }
                        height: 20
                        border.color: plusText.color
                        border.width: 1
                        color: "transparent"
                        Text {
                            id:minusText
                            text: "-"
                            anchors.fill:parent
                            font.pixelSize: 12
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                            color: "black"
                            elide: Text.ElideRight
                        }
                    }
                }


                Flickable  {
                    id:droneFlickable
                    height:mainColumn.height - mainColumn.spacing * (mainColumn.children.length-1) - row0.height-row1.height-row1_2.height-row2.height-row3.height
                    width: 130
                    interactive: true
                    clip: true
                    flickableDirection: Flickable.VerticalFlick
                    contentHeight: dataLV.height
                    ScrollBar.vertical: ScrollBar {
                        policy: (droneFlickable.contentHeight>droneFlickable.height)?ScrollBar.AlwaysOn:ScrollBar.AlwaysOff
                    }

                    ListView{
                        id: dataLV
                        width: parent.width
                        height: childrenRect.height
                        clip: true
                        interactive: false
                        model: infoSelectedNamesInfo
                        property variant columnWidths: Algos.calcColumnWidths(model, dataLV)

                        delegate: Component{
                            Item{
                                width: parent.width
                                height: row.height


                                Row{
                                    id: row
                                    width: parent.width
                                    spacing: 2

                                    Text{
                                        id: keyText
                                        text: infoSelectedNamesInfo[index]
                                        wrapMode: Text.WrapAnywhere
                                        width: dataLV.columnWidths
                                        renderType: Text.NativeRendering
                                    }
                                    Loader { sourceComponent: columnSeparator; height: keyText.height>valueText.height?keyText.height:valueText.height}
                                    Text{
                                        id: valueText
                                        text: infoSelectedValuesInfo[index]
                                        color: valueText.text.includes("\u2227")?"green":(text.includes("\u2228")?"red":"black")
                                        wrapMode: Text.WrapAnywhere
                                        width: parent.width - dataLV.columnWidths
                                        renderType: Text.NativeRendering
                                    }
                                    Component {
                                        id: columnSeparator
                                        Rectangle {
                                            width: 1
                                            color: "black"
                                            opacity: 0.3
                                        }
                                    }
                                }
                            }
                        }
                        onCountChanged: droneFlickable.returnToBounds();
                    }
                }
            }


        }
    }


}
