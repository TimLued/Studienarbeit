import QtQuick 2.13
import QtQuick.Controls 2.13
import QtPositioning 5.13
import "algos.js" as Algos

Item {
    id: content
    visible: false
    property bool editing: false
    property bool addingDrones: false
    property bool addingCor: false
    function show(edit){
        content.visible = true
        editing=edit
        clearModels()
        if(editing){//load drone missions


        }else{
            missionModel.append({ID:"Mission",tasks:[]})
            missionListView.currentIndex=0
        }
    }
    function hide(){
        content.visible = false
        clearModels()
        taskButtons.uncheckBtns()
        editTaskBtn.checked = false
        addingDrones = false
        addingCor = false
    }
    function clearModels(){
        missionModel.clear()
        taskModel.clear()
        corModel.clear()
        dronesModel.clear()
    }

    function addDrone(drone){if(!modelContains(dronesModel,drone)) dronesModel.append({"ID":drone})}
    function addCor(lat,lon){
        //set cors in missionmodel missionindex&taskindex
        missionModel.addCor(missionListView.currentIndex,taskListView.currentIndex,{"lat":lat,"lon":lon})
        updateCorModel(taskListView.currentIndex)

    }
    width: 200
    height: editing? 325:childrenRect.height

    Rectangle{
        id:background
        anchors.fill:parent
        color:"white"
        //opacity: 0.8
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
                    contentHeight: missionListView.height + btnRow.height + 2
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
                            opacity: 0.3
                            z:4
                        }
                        focus:true
                        model: missionModel
                        onCurrentIndexChanged:{
                            if (currentIndex != -1)
                                taskModel.update(currentIndex)
                            else taskModel.clear()
                        }


                        delegate:Rectangle{
                            z:1
                            width: parent.width
                            height: missionText.height
                            MouseArea{
                                anchors.fill: parent
                                onClicked: missionListView.currentIndex = index
                            }
                            anchors{
                                left:parent.left
                                right:parent.right
                                margins: 5
                                rightMargin: 10
                            }

                            Text{
                                id: missionText
                                text: ID
                                z:2
                                wrapMode: Text.WrapAnywhere
                                width: parent.width
                                renderType: Text.NativeRendering
                                anchors{
                                    left:parent.left
                                    right: missionDelBtn.left
                                }
                                leftPadding: 3
                            }

                            TextField{
                                id: missionTextField
                                z:3
                                padding: 0
                                leftPadding: 2
                                visible: editMissionBtn.checked
                                anchors.fill: parent
                                text: missionText.text
                                selectByMouse: true
                                background: Rectangle {border.width: 0}
                                onVisibleChanged: {
                                    if (!visible&&!modelContains(missionModel,text)){
                                        missionModel.setProperty(index,"ID",text)
                                    }
                                }
                            }

                            Text{
                                id:missionDelBtn
                                z:2
                                text: "X"
                                color: "#FF5733"
                                anchors.right: parent.right
                                height: parent.height
                                verticalAlignment: Text.AlignVCenter
                                MouseArea{
                                    anchors.fill:parent
                                    onClicked: {
                                        missionModel.remove(index)
                                        missionListView.currentIndex=-1
                                    }
                                }
                            }
                        }

                        onCountChanged: parent.parent.returnToBounds();
                    }
                    Row{
                        id:btnRow
                        spacing: 3
                        anchors{
                            horizontalCenter: parent.horizontalCenter
                            top: missionListView.bottom
                            topMargin: 2
                        }

                        RoundButton{
                            id: addMissionBtn
                            width: 20
                            height: width
                            radius: width/2
                            palette {button: checked? "black":"#3EC6AA"}
                            text: "+"
                            onClicked: missionModel.append({"ID":newName(missionModel,"Mission"),"tasks":[]})
                        }


                        RoundButton{
                            id: editMissionBtn
                            enabled:missionListView.model.count>0
                            width: 20
                            height: width
                            radius: width/2
                            checkable: true
                            palette {button: checked? "black":"#3EC6AA"}
                            text: "\u26ED"

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
                    contentHeight: taskListView.height+editTaskBtn.height
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
                            opacity: 0.3
                            z:4
                        }
                        focus:true
                        model:missionListView.currentIndex!=-1?missionModel.get(missionListView.currentIndex).tasks:emptyModel

                        onCurrentIndexChanged:{
                            if (currentIndex != -1)
                                updateCorModel(currentIndex)
                            else corModel.clear()
                        }

                        delegate: Rectangle{
                            z:1
                            width: parent.width
                            height: taskText.height
                            MouseArea{
                                anchors.fill: parent
                                onClicked: taskListView.currentIndex = index
                            }
                            anchors{
                                left:parent.left
                                right:parent.right
                                margins: 5
                                rightMargin: 10
                            }

                            Text{
                                id: taskText
                                z:2
                                text: (index+1) + ". " + ID
                                wrapMode: Text.WrapAnywhere
                                width: parent.width
                                renderType: Text.NativeRendering
                                anchors{
                                    left:parent.left
                                    right: taskDelBtn.left
                                }
                            }

                            TextField{
                                id: taskTextField
                                z:3
                                padding: 0
                                leftPadding: 0
                                visible: editTaskBtn.checked
                                anchors.fill: parent
                                text: taskText.text.replace((index+1) + ". ","")
                                selectByMouse: true
                                background: Rectangle {border.width: 0}
                                onVisibleChanged: {
                                    if (!visible&&!modelContains(taskModel,text)){
                                        missionModel.get(missionListView.currentIndex).tasks.get(index).ID = text
                                        taskModel.update(missionListView.currentIndex)
                                        taskListView.currentIndex = index
                                    }else{
                                        text = taskText.text.replace((index+1) + ". ","")
                                    }

                                }
                            }


                            Text{
                                id:taskDelBtn
                                z:2
                                text: "X"
                                color: "#FF5733"
                                anchors.right: parent.right
                                height: parent.height
                                verticalAlignment: Text.AlignVCenter
                                MouseArea{
                                    anchors.fill:parent
                                    onClicked: {
                                        missionModel.get(missionListView.currentIndex).tasks.remove(index)
                                        taskModel.update(missionListView.currentIndex)
                                        taskListView.currentIndex=-1
                                        //corModel.update(taskListView.currentIndex)
                                    }
                                }
                            }
                        }
                        onCountChanged: parent.parent.returnToBounds();
                    }

                    RoundButton{
                        id: editTaskBtn
                        width: 20
                        height: width
                        radius: width/2
                        anchors{
                            top: taskListView.bottom
                            horizontalCenter: parent.horizontalCenter
                        }
                        enabled:taskListView.model.count>0
                        checkable: true
                        palette {button: checked? "black":"#3EC6AA"}
                        text: "\u26ED"
                        onCheckedChanged: addingCor = checked

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
                        if(missionListView.currentIndex!=-1){
                            if(!parent.checked) parent.parent.uncheckBtns()
                            parent.checked = !parent.checked

                            addingCor = parent.checked

                            if(parent.checked){
                                missionModel.addTask(missionListView.currentIndex,{"ID":newName(taskModel,"Task"),
                                                         "geoType":"path",
                                                         "taskType":"",
                                                         pValues:[]})
                                taskModel.update(missionListView.currentIndex)
                            }
                            taskListView.currentIndex = taskModel.count-1
                        }
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
                        addingCor = parent.checked
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
                        addingCor = parent.checked
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
                        addingCor = parent.checked
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
                    enabled: editTaskBtn.checked||pathBtn.checked //NEEDS EDIT
                    text: (taskListView.currentIndex!=-1)?taskModel.get(taskListView.currentIndex).taskType:""
                    padding: 3
                    selectByMouse: true
                    background: Rectangle {
                        anchors.fill:parent
                        border.color: "#3EC6AA"
                    }
                    onEnabledChanged: {
                        if(!enabled&&missionListView.currentIndex!=-1&&taskListView.currentIndex!=-1){
                            missionModel.get(missionListView.currentIndex).tasks.get(taskListView.currentIndex).taskType = text
                            taskModel.update(missionListView.currentIndex)
                        }
                    }
                }
            }


            Text{
                id:typeText
                width: parent.width
                property string type: (taskListView.currentIndex!=-1)? taskModel.get(taskListView.currentIndex).geoType:""
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
                    contentHeight: geoListView.height
                    ScrollBar.vertical: ScrollBar {
                        policy: (parent.contentHeight>parent.height)?ScrollBar.AlwaysOn:ScrollBar.AlwaysOff
                    }

                    ListView{
                        id: geoListView
                        width: parent.width
                        height: childrenRect.height
                        clip: true
                        interactive: false
                        focus:true
                        model: corModel
                        property variant columnWidths: Algos.calcTxtWidth("99", typeText)

                        delegate: Item{
                            width: parent.width
                            height: row.height

                            Row{
                                id: row
                                width: parent.width
                                spacing: 2

                                Text{
                                    id: keyText
                                    text: (index+1)+": "
                                    wrapMode: Text.WrapAnywhere
                                    width: geoListView.columnWidths
                                    renderType: Text.NativeRendering
                                }
                                Loader { sourceComponent: columnSeparator; height: keyText.height>valueText.height?keyText.height:valueText.height}
                                Text{
                                    id: valueText
                                    text:  Algos.roundNumber(lat,3) +"," + Algos.roundNumber(lon,3)
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
        //        ListElement{
        //            ID:"Mission 1"
        //            tasks:[
        //                ListElement{
        //                    ID:"Task 1"
        //                    geoType:"rechteck"
        //                    taskType:"aufklären"
        //                    pValues:[
        //                        ListElement{
        //                            lat: 54.31
        //                            lon: 10.12
        //                        },
        //                        ListElement{
        //                            lat: 54.50
        //                            lon: 10.10
        //                        }
        //                    ]
        //                }
        //            ]
        //        }
        function addTask(index,task){
            missionModel.get(index).tasks.append(task)
        }

        function addCor(index,task,cor){
            missionModel.get(index).tasks.get(task).pValues.append(cor)
        }

    }
    ListModel{
        id: taskModel
        //        ListElement{
        //            ID:"Task 1"
        //            geoType:"rect"
        //            taskType:"aufklären"
        //            pValues:[
        //                ListElement{
        //                    lat: 54.31
        //                    lon: 10.12
        //                },
        //                ListElement{
        //                    lat: 54.50
        //                    lon: 10.10
        //                }
        //            ]
        //        }

        function update(missionIndex){
            taskModel.clear()
            for (var i = 0; i<missionModel.get(missionIndex).tasks.count;i++){
                taskModel.append(missionModel.get(missionIndex).tasks.get(i))
            }
        }

    }


    ListModel{id:dronesModel}
    ListModel{id:emptyModel}

    function updateCorModel(taskIndex){
        corModel.clear()
        for (var i = 0; i<taskModel.get(taskIndex).pValues.count;i++){
            corModel.append(taskModel.get(taskIndex).pValues.get(i))
        }
    }


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

    function modelContains(model,id){
        for (var i = 0; i < model.count; i++) {
            if (model.get(i).ID===id){
                return true
            }
        }
        return false
    }

}
