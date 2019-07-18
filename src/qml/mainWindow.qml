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

Window {
    visible: true
    width: 640
    height: 480
    title: qsTr("Typing.io")
    flags: Qt.MSWindowsFixedSizeDialogHint | Qt.Window | Qt.WindowCloseButtonHint

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
        anchors.leftMargin: 200
        anchors.bottomMargin: 100
        anchors.rightMargin: 200
        anchors.topMargin: 100
        anchors.fill: parent
        spacing: 4

        Button {
            id: uploadSourceCodeButton
            height: 50
            width: parent.width
            buttonText: "Upload Source Code"
            onClicked: {

            }
        }
        Button {
            id: practiceButton
            height: 50
            width: parent.width
            buttonText: "Practice!"
            onClicked: {

            }
        }
        Button {
            id: exitButton
            height: 50
            width: parent.width
            buttonText: "Exit"
            onClicked: {
                exit();
            }
        }
    }
}
