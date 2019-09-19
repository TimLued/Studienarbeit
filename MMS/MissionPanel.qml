import QtQuick 2.13
import QtQuick.Controls 2.13
import QtPositioning 5.13
import "algos.js" as Algos

Item {
    id: content
    visible: false
    property bool editing: false
    property bool addingDrones: false
    function show(edit){content.visible = true;editing=edit}
    function hide(){content.visible = false}
    function addDrone(drone){
        if(!modelContains(dronesModel,drone)) dronesModel.append({"ID":drone})
    }

    width: 200
    height: editing? 325:childrenRect.height

    Rectangle{
        id:background
        anchors.fill:parent
        color:"white"
        opacity: 0.8
    }

    Rectangle {
        id: header
        color: "#3EC6AA"
        height: 30
        width:parent.width

        Text {
            anchors.centerIn: parent
            text: "Mission"
            font.pixelSize: 14
            font.letterSpacing: 2
        }

        Text{
            text: "X"
            font.pixelSize: 16
            anchors.right: parent.right
            anchors.rightMargin: 20
            height: parent.height
            verticalAlignment: Text.AlignVCenter
            MouseArea{
                anchors.fill:parent
                onClicked: {

                    hide()
                }
            }
        }
    }

    Column{
        id:mainContent
        spacing: 3
        layer.enabled: true
        anchors{
            top: header.bottom
            left: parent.left
            right: parent.right
            margins: 5
        }

        Text{
            id:taskHeader
            text: !content.editing? "Task":"Mission / Task"
            font.pixelSize: 13
            color:"black"
            anchors{
                left: parent.left
                right: parent.right
            }
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter

            Rectangle{
                height: 1
                width: parent.width / 2 - Algos.calcTxtWidth(parent.text,parent) / 2 - 10
                color:"black"
                anchors{
                    left: parent.left
                    verticalCenter: parent.verticalCenter
                }
            }
            Rectangle{
                height: 1
                width: parent.width / 2 - Algos.calcTxtWidth(parent.text,parent) / 2 - 10
                color:"black"
                anchors{
                    right: parent.right
                    verticalCenter: parent.verticalCenter
                }
            }
        }

        Row{
            spacing: 2
            Rectangle{
                height: 60
                width: !content.editing? 0:(parent.parent.width/2-parent.spacing)
                color:"transparent"
                border.width: 1
                border.color: "#3EC6AA"

                Flickable  {
                    anchors{
                        fill:parent
                        topMargin: 4
                        bottomMargin: 4
                    }
                    interactive: true
                    clip: true
                    flickableDirection: Flickable.VerticalFlick
                    contentHeight: missionListView.height + addMissionBtn.height + addMissionBtn.anchors.topMargin
                    ScrollBar.vertical: ScrollBar {
                        policy: (parent.contentHeight>parent.height)?ScrollBar.AlwaysOn:ScrollBar.AlwaysOff
                    }

                    ListView{
                        id: missionListView
                        width: parent.width
                        height: childrenRect.height
                        clip: true
                        interactive: false
                        spacing: 1
                        highlight: Rectangle{
                            color: "lightgrey"
                            opacity: 0.6
                            anchors.leftMargin: 2
                            anchors.rightMargin: 2
                        }
                        focus:true
                        model: missionModel


                        delegate:Item{
                            width: parent.width
                            height: missionText.height
                            MouseArea{
                                anchors.fill: parent
                                onClicked: missionListView.currentIndex = index
                            }

                            Text{
                                id: missionText
                                text: ID
                                wrapMode: Text.WrapAnywhere
                                width: parent.width
                                renderType: Text.NativeRendering
                                anchors{
                                    left:parent.left
                                    margins:5
                                    right: missionDelBtn.left
                                }
                            }

                            Text{
                                id:missionDelBtn
                                text: "X"
                                color: "#FF5733"
                                anchors{
                                    right: parent.right
                                    verticalCenter: parent.verticalCenter
                                    rightMargin: 10
                                }
                                height: parent.height
                                verticalAlignment: Text.AlignVCenter
                                MouseArea{
                                    anchors.fill:parent
                                    onClicked: {
                                        missionModel.remove(index)
                                    }
                                }
                            }
                        }

                        onCountChanged: parent.parent.returnToBounds();
                    }

                    Rectangle{
                        id: addMissionBtn
                        width: 20
                        height: width
                        radius: width/2
                        anchors{
                            horizontalCenter: parent.horizontalCenter
                            top: missionListView.bottom
                            topMargin: 3
                        }
                        MouseArea{
                            anchors.fill:parent
                            onClicked:missionModel.append({"ID":newName(missionModel,"Mission"),"tasks":[]})
                        }
                        color: "#3EC6AA"
                        Text {
                            text: "+"
                            width:parent.width
                            height:parent.height
                            font.pixelSize: 16
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                            y:-1
                            color: "black"
                            elide: Text.ElideRight
                        }
                    }
                }
            }

            Rectangle{
                height: 60
                width: !content.editing? parent.parent.width:(parent.parent.width/2-parent.spacing)
                color:"transparent"
                border.width: 1
                border.color: "#3EC6AA"

                Flickable  {
                    anchors{
                        fill:parent
                        topMargin: 4
                        bottomMargin: 4
                    }
                    interactive: true
                    clip: true
                    flickableDirection: Flickable.VerticalFlick
                    contentHeight: taskListView.height
                    ScrollBar.vertical: ScrollBar {
                        policy: (parent.contentHeight>parent.height)?ScrollBar.AlwaysOn:ScrollBar.AlwaysOff
                    }

                    ListView{
                        id: taskListView
                        width: parent.width
                        height: childrenRect.height
                        clip: true
                        interactive: false
                        spacing: 1
                        highlight: Rectangle{
                            color: "lightgrey"
                            opacity: 0.6
                            anchors.leftMargin: 2
                            anchors.rightMargin: 2
                        }


                        focus:true
                        model: missionListView.currentIndex!==-1? missionModel.get(missionListView.currentIndex).tasks:emptyModel

                        delegate: Item{
                            width: parent.width
                            height: taskText.height
                            MouseArea{
                                anchors.fill: parent
                                onClicked: taskListView.currentIndex = index
                            }

                            Text{
                                id: taskText
                                text: (index+1) + ". " + ID
                                wrapMode: Text.WrapAnywhere
                                width: parent.width
                                renderType: Text.NativeRendering
                                anchors{
                                    left:parent.left
                                    margins:5
                                    right: taskDelBtn.left
                                }
                            }

                            Text{
                                id:taskDelBtn
                                text: "X"
                                color: "#FF5733"
                                anchors{
                                    right: parent.right
                                    verticalCenter: parent.verticalCenter
                                    rightMargin: 10
                                }
                                height: parent.height
                                verticalAlignment: Text.AlignVCenter
                                MouseArea{
                                    anchors.fill:parent
                                    onClicked: {
                                        missionModel.get(missionListView.currentIndex).tasks.remove(index)

                                    }
                                }
                            }
                        }

                        onCountChanged: parent.parent.returnToBounds();
                    }
                }
            }
        }

        Row{
            id: taskButtons
            spacing: 4
            anchors.horizontalCenter: parent.horizontalCenter

            function uncheckBtns(){
                pathBtn.checked = false
                circleBtn.checked = false
                rectangleBtn.checked = false
                polygonBtn.checked = false
            }

            Rectangle{
                id: pathBtn
                property bool checked: false
                width: 30
                height: width
                radius: width / 2
                color: checked? "black":"#3EC6AA"
                Text {
                    text: "\u219D"
                    y:-1
                    width:parent.width
                    height:parent.height
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                    font.pixelSize:30
                    color: parent.checked? "white":"black"
                    elide: Text.ElideRight
                }
                MouseArea{
                    anchors.fill:parent
                    onClicked: {
                        if(!parent.checked) parent.parent.uncheckBtns()
                        parent.checked = !parent.checked
                    }
                }
            }

            Rectangle{
                id: circleBtn
                property bool checked: false
                width: 30
                height: width
                radius: width / 2
                color: checked? "black":"#3EC6AA"
                Text {
                    text: "\u2299"
                    y:-1
                    width:parent.width
                    height:parent.height
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                    font.pixelSize:40
                    color: parent.checked? "white":"black"
                    elide: Text.ElideRight
                }
                MouseArea{
                    anchors.fill:parent
                    onClicked: {
                        if(!parent.checked) parent.parent.uncheckBtns()
                        parent.checked = !parent.checked
                    }
                }
            }

            Rectangle{
                id: rectangleBtn
                property bool checked: false
                width: 30
                height: width
                radius: width / 2
                color: checked? "black":"#3EC6AA"
                Text {
                    text: "\u25A7"
                    width:parent.width
                    height:parent.height
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                    font.pixelSize:30
                    color: parent.checked? "white":"black"
                    elide: Text.ElideRight
                }
                MouseArea{
                    anchors.fill:parent
                    onClicked: {
                        if(!parent.checked) parent.parent.uncheckBtns()
                        parent.checked = !parent.checked
                    }
                }
            }

            Rectangle{
                id: polygonBtn
                property bool checked: false
                width: 30
                height: width
                radius: width / 2
                color: checked? "black":"#3EC6AA"
                Text {
                    text: "\u2B21"
                    y:-1
                    width:parent.width
                    height:parent.height
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                    font.pixelSize:23
                    color: parent.checked? "white":"black"
                    elide: Text.ElideRight
                }
                MouseArea{
                    anchors.fill:parent
                    onClicked: {
                        if(!parent.checked) parent.parent.uncheckBtns()
                        parent.checked = !parent.checked
                    }
                }
            }
        }

        Text{
            id:descrHeader
            text: "Description"
            font.pixelSize:13
            color:"black"
            anchors{
                left: parent.left
                right: parent.right
            }
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter

            Rectangle{
                height: 1
                width: parent.width / 2 - Algos.calcTxtWidth(parent.text,parent) / 2 - 10
                color:"black"
                anchors{
                    left: parent.left
                    verticalCenter: parent.verticalCenter
                }
            }
            Rectangle{
                height: 1
                width: parent.width / 2 - Algos.calcTxtWidth(parent.text,parent) / 2 - 10
                color:"black"
                anchors{
                    right: parent.right
                    verticalCenter: parent.verticalCenter
                }
            }
        }

        Column{
            spacing: 3
            width: parent.width
            height: childrenRect.height


            ScrollView{
                width:parent.parent.width
                height: 50
                TextArea {
                    id: descriptionText
                    text: (taskListView.currentIndex!=-1&&missionListView.currentIndex!=-1)?missionModel.get(missionListView.currentIndex).tasks.get(taskListView.currentIndex).taskType:""
                    padding: 3
                    selectByMouse: true
                    background: Rectangle {
                        anchors.fill:parent
                        border.color: "#3EC6AA"
                    }
                }
            }


            Text{
                id:typeText
                width: parent.width
                property string type: (taskListView.currentIndex!=-1&&missionListView.currentIndex!=-1)? missionModel.get(missionListView.currentIndex).tasks.get(taskListView.currentIndex).geoType:""
                text: "<b>Typ</b>: " + type
            }


            Rectangle{
                height: 50
                width: parent.width
                color:"transparent"
                border.width: 1
                border.color: "#3EC6AA"

                Flickable  {
                    anchors{
                        fill:parent
                        topMargin: 4
                        leftMargin: 5
                        bottomMargin: 4
                    }
                    interactive: true
                    clip: true
                    flickableDirection: Flickable.VerticalFlick
                    contentHeight: taskListView.height
                    ScrollBar.vertical: ScrollBar {
                        policy: (parent.contentHeight>parent.height)?ScrollBar.AlwaysOn:ScrollBar.AlwaysOff
                    }

                    ListView{
                        id: geoListView
                        width: parent.width
                        height: childrenRect.height
                        clip: true
                        interactive: false
                        spacing: 1

                        focus:true
                        model: (missionListView.currentIndex!==-1&&taskListView.currentIndex!==-1)? missionModel.get(missionListView.currentIndex).tasks.get(taskListView.currentIndex).pValues:emptyModel

                        property variant columnWidths: Algos.calcTxtWidth("Pos 10", typeText)

                        delegate: Item{
                            width: parent.width
                            height: keyText.height

                            Row{
                                id: row
                                width: parent.width
                                spacing: 2

                                Text{
                                    id: keyText
                                    text: "Cor " + (index+1)
                                    wrapMode: Text.WrapAnywhere
                                    width: geoListView.columnWidths
                                    renderType: Text.NativeRendering
                                }
                                Loader { sourceComponent: columnSeparator; height: keyText.height>valueText.height?keyText.height:valueText.height}
                                Text{
                                    id: valueText
                                    text: lat +"," + lon
                                    wrapMode: Text.WrapAnywhere
                                    width: parent.width - geoListView.columnWidths
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


                        onCountChanged: parent.parent.returnToBounds();
                    }
                }
            }


        }











        Text{
            id:droneHeader
            visible: !content.editing
            text: "Drones"
            font.pixelSize: 13
            color:"black"
            anchors{
                left: parent.left
                right: parent.right
            }
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter

            Rectangle{
                height: 1
                width: parent.width / 2 - Algos.calcTxtWidth(parent.text,parent) / 2 - 10
                color:"black"
                anchors{
                    left: parent.left
                    verticalCenter: parent.verticalCenter
                }
            }
            Rectangle{
                height: 1
                width: parent.width / 2 - Algos.calcTxtWidth(parent.text,parent) / 2 - 10
                color:"black"
                anchors{
                    right: parent.right
                    verticalCenter: parent.verticalCenter
                }
            }
        }

        Row{
            spacing: 5

            Rectangle{
                height:content.editing? 0:40
                width: parent.parent.width - addBtn.width - parent.spacing
                color:"white"
                border.width: 1
                border.color: "#3EC6AA"

                Flickable  {
                    id:droneListFlickable
                    anchors{
                        fill:parent
                        topMargin: 4
                        bottomMargin: 4
                    }

                    interactive: true
                    clip: true
                    flickableDirection: Flickable.VerticalFlick
                    contentHeight: droneListView.height
                    ScrollBar.vertical: ScrollBar {policy: (droneListFlickable.contentHeight>droneListFlickable.height)?ScrollBar.AlwaysOn:ScrollBar.AlwaysOff}


                    ListView{
                        id: droneListView
                        width: parent.width
                        height: childrenRect.height
                        clip: true
                        interactive: false
                        spacing: 1
                        model:dronesModel

                        delegate: Component{
                            Item{
                                height: droneText.height
                                width:parent.width

                                Text{
                                    id: droneText
                                    text: ID
                                    wrapMode: Text.WrapAnywhere
                                    renderType: Text.NativeRendering
                                    anchors{
                                        left:parent.left
                                        leftMargin: 5
                                        right: droneDelBtn.left
                                    }
                                }

                                Text{
                                    id:droneDelBtn
                                    text: "X"
                                    color: "#FF5733"
                                    anchors{
                                        right: parent.right
                                        verticalCenter: parent.verticalCenter
                                        rightMargin: 10
                                    }
                                    height: parent.height
                                    verticalAlignment: Text.AlignVCenter
                                    MouseArea{
                                        anchors.fill:parent
                                        onClicked: {
                                            dronesModel.remove(index)
                                        }
                                    }
                                }
                            }
                        }
                        onCountChanged: parent.parent.returnToBounds();
                    }
                }
            }

            Rectangle{
                id: addBtn
                property bool checked:false
                visible: !content.editing
                width: 30
                height: width
                radius: width / 2
                color: checked? "black":"#3EC6AA"
                Text {
                    text: "+"
                    width:parent.width
                    height:parent.height
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                    font.pixelSize:20
                    color: parent.checked? "white":"black"
                    y:-1
                    elide: Text.ElideRight
                }
                MouseArea{
                    anchors.fill:parent
                    onClicked: {
                        parent.checked = !parent.checked
                        addingDrones = parent.checked
                    }
                }
            }

        }



            Rectangle{
                id: finishBtn
                width: 30
                height: width
                radius: width / 2
                color: "#3EC6AA"
                anchors.horizontalCenter: parent.horizontalCenter

                Text {
                    text: "\u2713"
                    width:parent.width
                    height:parent.height
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                    font.pixelSize:20
                    color: "black"
                    elide: Text.ElideRight
                }
                MouseArea{
                    anchors.fill:parent
                    onClicked: {
                        hide()
                    }
                }
            }


        Rectangle{height:4;width:parent.width;color:"transparent"}

    }

    //Models for creating NEW missions with tasks
    ListModel{
        id: missionModel
        ListElement{
            ID:"Mission 1"
            tasks:[
                ListElement{
                    ID:"Task 1"
                    geoType:"rechteck"
                    taskType:"aufklären"
                    pValues:[
                        ListElement{
                            lat: 54.31
                            lon: 10.12
                        },
                        ListElement{
                            lat: 54.50
                            lon: 10.10
                        }
                    ]
                }
            ]
        }
    }
    ListModel{id: dronesModel}
    ListModel{id:emptyModel}

    function newName(model,prefix){
        var nr = 1
        var name = prefix + " " + nr

        restart:
        for (var i = 0; i < model.count; i++) {
            if (model.get(i).ID === name) {
                nr+=1
                name = prefix + " " + nr
                continue restart
            }
        }
        return name
    }

    function modelContains(model,item){
        for (var i = 0; i < model.count; i++) {
            if (model.get(i).ID===item){
                return true
            }
        }
        return false
    }

}
