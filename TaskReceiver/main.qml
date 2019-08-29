import QtQuick 2.13
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

ApplicationWindow {
    visible: true
    width: 640
    height: 480
    title: "UAV Task Receiver"

    TaskList{
        anchors.centerIn: parent
    }
}

