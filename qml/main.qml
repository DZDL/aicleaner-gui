import QtQuick 6
import QtQuick.Window 2.15
import QtQuick.Controls 6
import QtQuick.Controls.Material 2.15

ApplicationWindow{
    id: window 
    width: 350
    height: 400
    visible: true
    title: qsTr("Ai Cleaner v0.2 (Beta)")

    // SET FLAGS
    flags: Qt.WindowCloseButtonHint | Qt.WindowMinimizeButtonHint | Qt.CustomizeWindowHint | Qt.MSWindowsFixedSizeDialogHint | Qt.WindowTitleHint

    // SET MATERIAL STYLE
    Material.theme: Material.Dark
    Material.accent: Material.LightBlue

    // IMAGE IMPORT
    Image{
        id: image 
        width: 300
        height: 100
        source: "../images/logo.png"
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: 0
    }

    // TEXT LABEL INSTALL
    Text{
        id:labelFieldTitle1
        width:300
        text:qsTr("1. Install Core")
        font.pointSize: 10
        color: "#FFFFFF"
        verticalAlignment: Text.AlignVCenter
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: image.bottom
    }

    // TEXT BUTTON INSTALL
    Button{
        id: buttonInstall
        width: 300
        text: qsTr("Install backend")
        anchors.top: labelFieldTitle1.bottom
        anchors.topMargin: 10
        anchors.horizontalCenter: parent.horizontalCenter
        onClicked: backend.installCoreBackend()
    }

    // PROGESSBAR INSTALL PYTHON BACKEND
    ProgressBar {
        id: progressBarInstallPythonBackend
        width: 300
        value: 0.0
        visible: true
        anchors.top: buttonInstall.bottom
        anchors.horizontalCenter: parent.horizontalCenter
    }

    // TEXT LABEL RUN CORE
    Text{
        id:nothing1
        width:300
        text: ""
        font.pointSize: 10
        color: "#FFFFFF"
        visible: false
        verticalAlignment: Text.AlignVCenter
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: progressBarInstallPythonBackend.bottom
    }

    // TEXT LABEL RUN CORE
    Text{
        id:labelFieldTitle2
        width:300
        text:qsTr("2. Run Core")
        font.pointSize: 10
        color: "#FFFFFF"
        verticalAlignment: Text.AlignVCenter
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: nothing1.bottom
    }

    // TEXT BUTTON RUN CORE
    Button{
        id: buttonRun
        width: 300
        text: qsTr("Run Core NOW!")
        anchors.top: labelFieldTitle2.bottom
        enabled:false
        anchors.topMargin: 10
        anchors.horizontalCenter: parent.horizontalCenter
        onClicked: backend.runCoreBackend()
    }

    // PROGESSBAR RUNNING CORE
    ProgressBar {
        id: progressBarRunningCore
        width: 300
        value: 0.0
        visible: true
        anchors.top: buttonRun.bottom
        anchors.horizontalCenter: parent.horizontalCenter
    }


    
    // TEXT FIELD LOG
    Text{
        id: myTexLog
        width: 300
        text: qsTr("")
        color: "#FFFFFF"
        // selectByMouse: true
        // placeholderText: qsTr("Log here")
        verticalAlignment: Text.AlignVCenter
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: progressBarRunningCore.bottom
        anchors.topMargin: 10
        // echoMode: TextInput.Password
    }

    
    Connections {
        target: backend

        // CUSTOM PROPERTIES
        // property string username: ""
        // property string password: ""


        // // CREATE STR TO STORE
        // function onSignalUser(myUser){
        //     username = myUser
        // }
        // function onSignalPass(myPass){
        //     password = myPass 
        // }


        // // FUNTION OPEN NEW WINDOW (APP WINDOW)
        // function onSignalLogin(boolValue) {
        //     if(boolValue){
        //         var component = Qt.createComponent("app.qml")
        //         var win = component.createObject()
        //         win.textUsername = username
        //         win.textPassword = password
        //         win.show()
        //         visible = false
        //     } else{
        //         // CHANGE USER COLOR
        //         usernameField.Material.foreground = Material.Pink
        //         usernameField.Material.accent = Material.Pink
        //         passwordField.Material.foreground = Material.Pink
        //         passwordField.Material.accent = Material.Pink
        //     }
        // }

        // FUNCTION BUTTON INSTALL
        function onSignalButtonInstall(boolValue){
            if(boolValue){
                buttonInstall.enabled = false
                progressBarInstallPythonBackend.indeterminate=true
                myTexLog.text="Log: onSignalButtonInstall"
            } 
        }

        // FUNCTION BUTON INSTALL ACTION FINISHED
        function onSignalInstalledCoreBackend(myBool){
            if(myBool){
                progressBarInstallPythonBackend.indeterminate=false
                progressBarInstallPythonBackend.value=1.0
                buttonInstall.text=buttonInstall.text+" (DONE)"
                myTexLog.text="Log: onSignalInstalledCoreBackend"
                buttonRun.enabled=true // enable button after install core
            } 
        }

        // FUNCTION BUTTON RUN
        function onSignalButtonRunCore(boolValue){
            if(boolValue){
                buttonRun.enabled = false
                progressBarRunningCore.indeterminate=true
                myTexLog.text="Log: onSignalButtonInstall"
                buttonRun.text=buttonRun.text+" (RUNNING)"
            } 
        }

        // FUNCTION BUTON RUN FINISHED
        function onSignalCoreBackendRunning(myBool){
            if(myBool){
                progressBarRunningCore.indeterminate=false
                progressBarRunningCore.value=1.0
                myTexLog.text="Log: onSignalInstalledCoreBackend"

            } 
        }
    }    
}
