import QtQuick 2.2
import QtQuick.Dialogs 1.1

MessageDialog {
    id: messageDialog
    function show(msg){
        text = msg
        open()
    }
    title: "Please note"
    onAccepted: visible = false
}
