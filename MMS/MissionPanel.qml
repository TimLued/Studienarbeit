import QtQuick 2.12
import QtQuick.Controls 2.12
import "algos.js" as Algos

Item {
    id: content
    visible: false
    function show(){content.visible = true}
    function hide(){content.visible = false}

    width: 200
    height: childrenRect.height
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
            text: "Mission / Task"
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
                width: parent.parent.width/2 - parent.spacing
                color:"transparent"
                border.width: 1
                border.color: "#3EC6AA"

                Flickable  {
                    id:missionListFlickable
                    anchors{
                        fill:parent
                        topMargin: 4
                        bottomMargin: 4
                    }
                    interactive: true
                    clip: true
                    flickableDirection: Flickable.VerticalFlick
                    contentHeight: missionListView.height
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
                        model: ListModel{
                            ListElement {
                                name: "Mission 1"
                            }
                        }

                        delegate: Component{
                            Item{
                                width: parent.width
                                height: taskText.height

                                Text{
                                    id: taskText
                                    text: model.name
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


                                        }
                                    }
                                }
                            }
                        }
                        onCountChanged: taskListFlickable.returnToBounds();
                    }
                }
            }

            Rectangle{
                height: 60
                width: parent.parent.width/2 - parent.spacing
                color:"transparent"
                border.width: 1
                border.color: "#3EC6AA"

                Flickable  {
                    id:taskListFlickable
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
                        policy: (taskListFlickable.contentHeight>taskListFlickable.height)?ScrollBar.AlwaysOn:ScrollBar.AlwaysOff
                    }

                    ListView{
                        id: taskListView
                        width: parent.width
                        height: childrenRect.height
                        clip: true
                        interactive: false
                        spacing: 1
                        model: ListModel{
                            ListElement {
                                name: "Path"
                            }
                            ListElement {
                                name: "Cicrle Area"
                            }
                            ListElement {
                                name: "Cicrle Area"
                            }
                            ListElement {
                                name: "Cicrle Area"
                            }
                        }

                        delegate: Component{
                            Item{
                                width: parent.width
                                height: taskText.height

                                Text{
                                    id: taskText
                                    text: (model.index+1) + ". " + model.name
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


                                        }
                                    }
                                }
                            }
                        }
                        onCountChanged: taskListFlickable.returnToBounds();
                    }
                }
            }


        }

        Row{
            id: taskButtons
            spacing: 4
            anchors.horizontalCenter: parent.horizontalCenter

            Rectangle{
                id: pathBtn
                width: 30
                height: width
                radius: width / 2
                color: "#3EC6AA"
                Text {
                    text: "\u219D"
                    y:-1
                    width:parent.width
                    height:parent.height
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                    font.pixelSize:30
                    color: "black"
                    elide: Text.ElideRight
                }
                MouseArea{
                    anchors.fill:parent
                    onClicked: {

                    }
                }
            }

            Rectangle{
                id: circleBtn
                width: 30
                height: width
                radius: width / 2
                color: "#3EC6AA"
                Text {
                    text: "\u2299"
                    y:-1
                    width:parent.width
                    height:parent.height
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                    font.pixelSize:40
                    color: "black"
                    elide: Text.ElideRight
                }
                MouseArea{
                    anchors.fill:parent
                    onClicked: {

                    }
                }
            }

            Rectangle{
                id: rectangleBtn
                width: 30
                height: width
                radius: width / 2
                color: "#3EC6AA"
                Text {
                    text: "\u25A7"
                    width:parent.width
                    height:parent.height
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                    font.pixelSize:30
                    color: "black"
                    elide: Text.ElideRight
                }
                MouseArea{
                    anchors.fill:parent
                    onClicked: {

                    }
                }
            }

            Rectangle{
                id: polygonBtn
                width: 30
                height: width
                radius: width / 2
                color: "#3EC6AA"
                Text {
                    text: "\u2B21"
                    y:-1
                    width:parent.width
                    height:parent.height
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                    font.pixelSize:23
                    color: "black"
                    elide: Text.ElideRight
                }
                MouseArea{
                    anchors.fill:parent
                    onClicked: {

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

        ScrollView{
            width:parent.width
            height: 50
            TextArea {
                id: descriptionText
                text: "id:\ncors:"
                padding: 2
                topPadding: 3
                bottomPadding: 3
                background: Rectangle {
                    anchors.fill:parent
                    border.color: "#3EC6AA"
                }
            }
        }

        Text{
            id:droneHeader
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
                height: 40
                width: parent.parent.width - addBtn.width - parent.spacing
                color:"transparent"
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
                        spacing: 2
                        model:ListModel {
                            ListElement {
                                name: "Alpha"
                            }
                            ListElement {
                                name: "Bravo"
                            }
                            ListElement {
                                name: "Bravo"
                            }
                            ListElement {
                                name: "Bravo"
                            }
                        }

                        delegate: Component{
                            Item{
                                height: droneText.height
                                width:parent.width

                                Text{
                                    id: droneText
                                    text: model.name
                                    wrapMode: Text.WrapAnywhere
                                    renderType: Text.NativeRendering
                                    anchors{
                                        left:parent.left
                                        margins:5
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


                                        }
                                    }
                                }
                            }
                        }
                        onCountChanged: taskListFlickable.returnToBounds();
                    }
                }
            }

            Rectangle{
                id: addBtn
                width: 30
                height: width
                radius: width / 2
                color: "#3EC6AA"
                Text {
                    text: "+"
                    width:parent.width
                    height:parent.height
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                    font.pixelSize:20
                    color: "black"
                    y:-1
                    elide: Text.ElideRight
                }
                MouseArea{
                    anchors.fill:parent
                    onClicked: {

                    }
                }
            }

        }

        Row{
            spacing:1
            anchors.horizontalCenter: parent.horizontalCenter
            Rectangle{
                id: finishBtn
                width: 30
                height: width
                radius: width / 2
                color: "#3EC6AA"

                Text {
                    text: "\u2713"
                    width:parent.width
                    height:parent.height
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                    font.pixelSize:23
                    color: "black"
                    elide: Text.ElideRight
                }
                MouseArea{
                    anchors.fill:parent
                    onClicked: {

                    }
                }
            }
        }

        Rectangle{height:4;width:parent.width;color:"transparent"}

    }






}
