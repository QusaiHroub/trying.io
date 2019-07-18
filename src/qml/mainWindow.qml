/* UI Typing.io
*
* This file is part of the Typing.io.
*
* Authors:
* Qusai Hroub <qusaihroub.r@gmail.com>
*
*/

import QtQuick 2.7
import QtQuick.Window 2.7
import QtQuick.Dialogs 1.2
import typing.io 0.1

Window {
    id: mainWindow
    visible: true
    width: 640
    height: 480
    title: qsTr("Typing.io")
    flags: Qt.MSWindowsFixedSizeDialogHint | Qt.Window | Qt.WindowCloseButtonHint

    property bool isSave: false;

    // To close the Application.
    function exit () {
        Qt.quit();
    }

    // Shortcut to call exit function.
    Shortcut {
        autoRepeat: false
        sequence: "Esc"
        onActivated: {
            exit();
        }
    }

    Column {
        spacing: 8
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter

        Text {
            text: qsTr("Main Menu")
            anchors.horizontalCenter: parent.horizontalCenter
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            font.pixelSize: 24
        }

        Rectangle {
            width: parent.width
            height: 60
            color: "#ffffff"
            border.color: "#00000000"
        }

        Column {
            spacing: 4

            Tbutton {
                id: uploadSourceCodeButton
                height: 50
                width: 230
                buttonText: "Upload Source Code"
                onClicked: {
                    uploadSourceCodeWindow.init();
                    uploadSourceCodeWindow.show();
                    hide();
                }
            }

            Tbutton {
                id: practiceButton
                height: 50
                width: 230
                buttonText: "Practice!"
                onClicked: {
                    if (isSave) {
                        practiceInterfaceWindow.init();
                        practiceInterfaceWindow.show();
                        hide();
                    } else {
                        notSaveDialog.open()
                    }
                }
            }

            Tbutton {
                id: exitButton
                height: 50
                width: 230
                buttonText: "Exit"
                onClicked: {
                    exit();
                }
            }
        }

    }

    UploadSourceCodeWindow {
        id: uploadSourceCodeWindow
        width: 800
        height: 800
        mainWindow: mainWindow
        typing: typing
    }

    PracticeInterfaceWindow {
        id: practiceInterfaceWindow
        width: 800
        height: 800
        mainWindow: mainWindow
        typing: typing
        resultsWindow: resultsWindow
    }

    ResultsWindow {
        id: resultsWindow
        width: 640
        height: 480
        mainWindow: mainWindow
        typing: typing
    }

    Typing {
        id: typing
    }

    // dialog that shown when the user going to practice without save code text.
    MessageDialog {
        id: notSaveDialog
        title: "Error"
        text: "Upload code befor start the practice"
        onAccepted: {
            uploadSourceCodeWindow.init();
            uploadSourceCodeWindow.show();
            hide();
        }
    }

}
