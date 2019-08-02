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
import QtQuick.Controls 2.5
import typing.io 0.1
import typing.io.userprogress 0.1
import typing.io.history 0.1

Window {
    width: 640
    height: 480
    flags: Qt.WindowTitleHint

    property Window mainWindow;
    property Typing typing;
    property UserProgress userProgress: typing.getUserProgress()

    History {
        id: userHistory
    }

    function init() {
        result.text = typing.getResult();
    }

    function finish() {
        userHistory.loadHistory();
        userHistory.append(typing.getResult(), userProgress.getDateAndTime());
        userHistory.saveHistory();
        mainWindow.show();
        hide();
    }

    Column {
        id: column
        spacing: 16
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter

        Text {
            text: "Your result"
            anchors.horizontalCenter: parent.horizontalCenter
            font.pixelSize: 24
        }

        // User result
        ScrollView {
            width: 400
            height: 300
            clip: true

            TextEdit {
                id: result
                width: 80
                height: 20
                readOnly: true
                font.family: "Verdana"
                font.pixelSize: 16
            }
        }

        // finish button.
        Tbutton {
            anchors.horizontalCenter: parent.horizontalCenter
            buttonText: "finish"
            height: 50
            width: 120
            onClicked: finish()
        }

    }

}
