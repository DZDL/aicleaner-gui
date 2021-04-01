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
        font.pointSize: 14
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

    
    Connections {
        target: backend

        // CUSTOM PROPERTIES
        property string username: ""
        property string password: ""

        property string logInstall: ""

        // CREATE STR TO STORE
        function onSignalUser(myUser){
            username = myUser
        }
        function onSignalPass(myPass){
            password = myPass 
        }
        function onSignalInstallLog(myInstallLog){
            logInstall = myInstallLog 
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

        // FUNCTION PROGRESS BAR
        function onSignalInstall(boolValue){
            if(boolValue){
                progressBarInstallPythonBackend.value=1.0
            } 
        }
    }    
}
