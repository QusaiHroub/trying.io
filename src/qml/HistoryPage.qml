/* UI Typing.io
*
* This file is part of the Typing.io.
*
* Authors:
* Qusai Hroub <qusaihroub.r@gmail.com>
*
*/

import QtQuick 2.7
import QtQuick.Window 2.12
import QtQuick.Controls 2.5

import typing.io 0.2
import typing.io.history 0.2

Item {
    width: 1690
    height: 1051

    property Window mainWindow;

    History {
        id: userHistory
    }

    function init() {
        userHistory.loadHistory();
        history.text = userHistory.getHistoryContent();
    }

    Rectangle {
        color: "#d9ffffff"
        border.color: "#3f51b5"
        border.width: 2
        anchors.top: parent.top
        anchors.topMargin: 100
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 100
        anchors.left: parent.left
        anchors.leftMargin: 200
        anchors.right: parent.right
        anchors.rightMargin: 200

        Column {
            anchors.topMargin: 8
            anchors.fill: parent
            spacing: 16

            Text {
                text: "Your history"
                anchors.horizontalCenter: parent.horizontalCenter
                font.pixelSize: 24
            }

            // User history
            Rectangle {
                height: parent.height - 120
                color: "#00000000"
                border.width: 0
                width: parent.width

                ScrollView {
                    id: scrollView
                    height: parent.height
                    anchors.horizontalCenter: parent.horizontalCenter
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

                // clear History button.
                TButton {
                    text: "clear"
                    height: 50
                    width: 200
                    onClicked: {
                        userHistory.clearHistory();
                        history.clear();
                    }
                }
            }
        }
    }
}
