import QtQuick 6
import QtQuick.Window 2.15
import QtQuick.Controls 6
import QtQuick.Controls.Material 2.15

ApplicationWindow{
    id: window 
    width: 350
    height: 500
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
        text:qsTr("1. Install backend")
        font.pointSize: 12
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
        onClicked: backend.installPythonBackend()
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

    // TEXT FIELD USERNAME
    TextField{
        id: usernameField
        width: 300
        text: qsTr("")
        selectByMouse: true
        placeholderText: qsTr("Your username or email")
        verticalAlignment: Text.AlignVCenter
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: buttonInstall.bottom
        anchors.topMargin: 60
    }

    // TEXT FIELD USERNAME
    TextField{
        id: passwordField
        width: 300
        text: qsTr("")
        selectByMouse: true
        placeholderText: qsTr("Your password")
        verticalAlignment: Text.AlignVCenter        
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: usernameField.bottom
        anchors.topMargin: 10
        echoMode: TextInput.Password
    }

    // CHECKBOX SAVE PASS
    CheckBox{
        id: checkBox
        text: qsTr("Save password")
        anchors.top: passwordField.bottom
        anchors.topMargin: 10        
        anchors.horizontalCenter: parent.horizontalCenter
        
    }

    // BUTTON LOGIN
    Button{
        id: buttonLogin
        width: 300
        text: qsTr("Login")
        anchors.top: checkBox.bottom
        anchors.topMargin: 10        
        anchors.horizontalCenter: parent.horizontalCenter
        onClicked: backend.checkLogin(usernameField.text, passwordField.text)
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
        anchors.top: buttonLogin.bottom
        anchors.topMargin: 10
        // echoMode: TextInput.Password
    }

    
    Connections {
        target: backend

        // CUSTOM PROPERTIES
        property string username: ""
        property string password: ""


        // CREATE STR TO STORE
        function onSignalUser(myUser){
            username = myUser
        }
        function onSignalPass(myPass){
            password = myPass 
        }


        // FUNTION OPEN NEW WINDOW (APP WINDOW)
        function onSignalLogin(boolValue) {
            if(boolValue){
                var component = Qt.createComponent("app.qml")
                var win = component.createObject()
                win.textUsername = username
                win.textPassword = password
                win.show()
                visible = false
            } else{
                // CHANGE USER COLOR
                usernameField.Material.foreground = Material.Pink
                usernameField.Material.accent = Material.Pink
                passwordField.Material.foreground = Material.Pink
                passwordField.Material.accent = Material.Pink
            }
        }

        // FUNCTION BUTTON INSTALL
        function onSignalButtonInstall(boolValue){
            if(boolValue){
                buttonInstall.enabled = false
                progressBarInstallPythonBackend.indeterminate=true
                myTexLog.text="onSignalButtonInstall"
            } 
        }

        // FUNCTION BUTON INSTALL ACTION FINISHED
        function onSignalInstalledCoreBackend(myBool){
            if(myBool){
                progressBarInstallPythonBackend.indeterminate=false
                progressBarInstallPythonBackend.value=1.0
                buttonInstall.text=buttonInstall.text+" (DONE)"
                myTexLog.text="onSignalInstalledCoreBackend"

            } 
        }

    }    
}
