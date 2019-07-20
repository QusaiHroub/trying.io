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
import typing.io.history 0.1


Window {
    width: 640
    height: 480
    flags: Qt.WindowTitleHint

    property Window mainWindow;

    History {
        id: userHistory
    }

    function init() {
        userHistory.loadHistory();
        history.text = userHistory.getHistory();
    }

    function close() {
        mainWindow.show();
        hide();
    }

    Column {
        id: column
        spacing: 16
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter

        Text {
            text: "Your history"
            anchors.horizontalCenter: parent.horizontalCenter
            font.pixelSize: 24
        }

        // User history
        Rectangle {
            height: 600
            width: 500

            ScrollView {
                id: scrollView
                height: 600
                clip: true
                TextEdit {
                    id: history
                    readOnly: true
                    font.family: "Verdana"
                    font.pixelSize: 16
                    onWidthChanged: {
                        if (history.width > 500) {
                            history.width = 500;
                        }
                    }
                }
            }
        }

        Row {
            spacing: 16
            anchors.horizontalCenter: parent.horizontalCenter

            // close button.
            Tbutton {
                buttonText: "close"
                height: 50
                width: 120
                onClicked: close()
            }

            // clear History button.
            Tbutton {
                buttonText: "clear"
                height: 50
                width: 120
                onClicked: {
                    userHistory.clearHistory();
                    history.clear();
                }
            }
        }
    }
}
