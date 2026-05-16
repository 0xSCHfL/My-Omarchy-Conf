import QtQuick 2.0
import SddmComponents 2.0

Rectangle {
    id: root
    color: "#0d0d0d"

    property string currentUser: userModel.lastUser
    property int sessionIndex: sessionModel.lastIndex
    property bool dropdownOpen: false

    // Pywal colors (with fallbacks)
    property string clrBg:     config.background || "#262626"
    property string clrFg:     config.foreground || "#c0b18b"
    property string clrAccent: config.accent     || "#d4d232"
    property string clrError:  config.error      || "#d75f5f"
    property string clrDim:    config.dimmed      || "#5a5a5a"

    // Wallpaper
    Image {
        anchors.fill: parent
        source: "bg.jpg"
        fillMode: Image.PreserveAspectCrop
        opacity: 0.35
    }

    // Vignette overlay
    Rectangle {
        anchors.fill: parent
        gradient: Gradient {
            GradientStop { position: 0.0; color: "#99000000" }
            GradientStop { position: 0.5; color: "#33000000" }
            GradientStop { position: 1.0; color: "#99000000" }
        }
    }

    Component.onCompleted: {
        for (var i = 0; i < sessionModel.rowCount(); i++) {
            var name = (sessionModel.data(sessionModel.index(i, 0), Qt.DisplayRole) || "").toString()
            if (name.toLowerCase() === "i3") { sessionIndex = i; break }
        }
        passwordInput.forceActiveFocus()
    }

    Connections {
        target: sddm
        function onLoginFailed() {
            errorMessage.text = "incorrect password"
            passwordInput.text = ""
            passwordInput.forceActiveFocus()
        }
        function onLoginSucceeded() {
            errorMessage.text = ""
        }
    }

    // Center column
    Column {
        anchors.centerIn: parent
        spacing: 0
        width: root.width * 0.28

        // Logo
        Image {
            source: "logo.svg"
            width: parent.width * 0.95
            height: Math.round(width * sourceSize.height / sourceSize.width)
            fillMode: Image.PreserveAspectFit
            anchors.horizontalCenter: parent.horizontalCenter
        }

        Item { width: 1; height: root.height * 0.025 }

        // Hostname
        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            text: sddm.hostName
            color: root.clrAccent
            font.family: "JetBrainsMono Nerd Font"
            font.pixelSize: root.height * 0.028
            font.bold: true
            font.letterSpacing: 2
        }

        Item { width: 1; height: root.height * 0.035 }

        // Card
        Rectangle {
            width: parent.width
            height: cardContents.implicitHeight + root.height * 0.06
            color: "#20000000"
            border.color: Qt.rgba(
                parseInt(root.clrAccent.slice(1,3), 16) / 255,
                parseInt(root.clrAccent.slice(3,5), 16) / 255,
                parseInt(root.clrAccent.slice(5,7), 16) / 255,
                0.25)
            border.width: 1
            radius: 8

            Column {
                id: cardContents
                anchors {
                    left: parent.left
                    right: parent.right
                    top: parent.top
                    margins: root.height * 0.03
                }
                spacing: root.height * 0.018

                // Username label
                Text {
                    text: "username"
                    color: root.clrDim
                    font.family: "JetBrainsMono Nerd Font"
                    font.pixelSize: root.height * 0.014
                    font.letterSpacing: 1
                }

                // Username field
                Rectangle {
                    width: parent.width
                    height: root.height * 0.042
                    color: "#40000000"
                    border.color: usernameInput.activeFocus ? root.clrAccent : "#303030"
                    border.width: 1
                    radius: 4

                    TextInput {
                        id: usernameInput
                        anchors.fill: parent
                        anchors.margins: root.height * 0.01
                        verticalAlignment: TextInput.AlignVCenter
                        text: currentUser
                        color: root.clrFg
                        font.family: "JetBrainsMono Nerd Font"
                        font.pixelSize: root.height * 0.019
                        clip: true
                        Keys.onReturnPressed: passwordInput.forceActiveFocus()
                        Keys.onTabPressed: passwordInput.forceActiveFocus()
                    }
                }

                Item { width: 1; height: root.height * 0.004 }

                // Password label
                Text {
                    text: "password"
                    color: root.clrDim
                    font.family: "JetBrainsMono Nerd Font"
                    font.pixelSize: root.height * 0.014
                    font.letterSpacing: 1
                }

                // Password field
                Rectangle {
                    width: parent.width
                    height: root.height * 0.042
                    color: "#40000000"
                    border.color: passwordInput.activeFocus ? root.clrAccent : "#303030"
                    border.width: 1
                    radius: 4

                    TextInput {
                        id: passwordInput
                        anchors.fill: parent
                        anchors.margins: root.height * 0.01
                        verticalAlignment: TextInput.AlignVCenter
                        echoMode: TextInput.Password
                        passwordCharacter: "•"
                        color: root.clrFg
                        font.family: "JetBrainsMono Nerd Font"
                        font.pixelSize: root.height * 0.02
                        font.letterSpacing: root.height * 0.004
                        clip: true

                        Keys.onPressed: {
                            if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                                sddm.login(usernameInput.text, passwordInput.text, sessionIndex)
                                event.accepted = true
                            }
                        }
                    }
                }

                Item { width: 1; height: root.height * 0.008 }

                // Login button
                Rectangle {
                    id: loginBtn
                    width: parent.width
                    height: root.height * 0.042
                    color: loginMouse.containsMouse ? Qt.lighter(root.clrAccent, 1.15) : root.clrAccent
                    radius: 4

                    Behavior on color { ColorAnimation { duration: 120 } }

                    Text {
                        anchors.centerIn: parent
                        text: "login"
                        color: "#111111"
                        font.family: "JetBrainsMono Nerd Font"
                        font.pixelSize: root.height * 0.018
                        font.bold: true
                        font.letterSpacing: 2
                    }

                    MouseArea {
                        id: loginMouse
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: sddm.login(usernameInput.text, passwordInput.text, sessionIndex)
                    }
                }

                // Error
                Text {
                    id: errorMessage
                    width: parent.width
                    horizontalAlignment: Text.AlignHCenter
                    text: ""
                    color: root.clrError
                    font.family: "JetBrainsMono Nerd Font"
                    font.pixelSize: root.height * 0.016
                    visible: text !== ""
                }
            }
        }

        Item { width: 1; height: root.height * 0.016 }

        // Session selector
        Rectangle {
            id: sessionBox
            width: parent.width
            height: root.height * 0.038
            color: "#20000000"
            border.color: "#2a2a2a"
            border.width: 1
            radius: 4

            Row {
                anchors { fill: parent; leftMargin: 10; rightMargin: 10 }
                spacing: 6

                Text {
                    text: ""
                    color: root.clrDim
                    font.family: "JetBrainsMono Nerd Font"
                    font.pixelSize: root.height * 0.016
                    anchors.verticalCenter: parent.verticalCenter
                }

                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    text: sessionModel.data(sessionModel.index(sessionIndex, 0), Qt.DisplayRole) || "i3"
                    color: root.clrFg
                    font.family: "JetBrainsMono Nerd Font"
                    font.pixelSize: root.height * 0.016
                }

                Item { width: 1; height: 1 }
            }

            Text {
                anchors.right: parent.right
                anchors.rightMargin: 10
                anchors.verticalCenter: parent.verticalCenter
                text: dropdownOpen ? "▲" : "▼"
                color: root.clrDim
                font.pixelSize: root.height * 0.013
            }

            MouseArea {
                anchors.fill: parent
                onClicked: dropdownOpen = !dropdownOpen
            }

            // Dropdown list
            Rectangle {
                anchors.bottom: parent.top
                anchors.bottomMargin: 2
                width: parent.width
                height: Math.min(sessionModel.rowCount(), 5) * root.height * 0.038
                color: "#e6161616"
                border.color: "#2a2a2a"
                border.width: 1
                radius: 4
                visible: dropdownOpen
                z: 10

                ListView {
                    anchors.fill: parent
                    anchors.margins: 2
                    model: sessionModel
                    clip: true
                    delegate: Rectangle {
                        width: parent.width
                        height: root.height * 0.038
                        color: itemMouse.containsMouse ? "#30ffffff" : "transparent"
                        radius: 3

                        Text {
                            anchors { fill: parent; leftMargin: 10 }
                            verticalAlignment: Text.AlignVCenter
                            text: model.name
                            color: index === sessionIndex ? root.clrAccent : root.clrFg
                            font.family: "JetBrainsMono Nerd Font"
                            font.pixelSize: root.height * 0.016
                        }

                        MouseArea {
                            id: itemMouse
                            anchors.fill: parent
                            hoverEnabled: true
                            onClicked: { sessionIndex = index; dropdownOpen = false }
                        }
                    }
                }
            }
        }
    }

    // Close dropdown on background click
    MouseArea {
        anchors.fill: parent
        z: -1
        onClicked: dropdownOpen = false
    }
}
