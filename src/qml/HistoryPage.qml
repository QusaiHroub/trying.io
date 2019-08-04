/* UI Trying.io
*
* This file is part of the Trying.io.
*
* Authors:
* Qusai Hroub <qusaihroub.r@gmail.com>
*
*/

import QtQuick 2.7
import QtQuick.Window 2.12
import QtQuick.Controls 2.5

import trying.io.typing 0.2
import trying.io.history 0.2

Item {
    width: 1690
    height: 1051

    property Window mainWindow;

    QtObject {
        id: internal

        readonly property int baseWidth: 1690
        readonly property int baseHeight: 1051
    }

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
        anchors.topMargin: parent.height * 100 / internal.baseHeight
        anchors.bottom: parent.bottom
        anchors.bottomMargin: parent.height * 100 / internal.baseHeight
        anchors.left: parent.left
        anchors.leftMargin: parent.width * 200 / internal.baseWidth
        anchors.right: parent.right
        anchors.rightMargin: parent.width * 200 / internal.baseWidth

        Column {
            anchors.topMargin: 8
            anchors.fill: parent
            spacing: 16

            Text {
                text: "Your history"
                font.bold: true
                anchors.horizontalCenter: parent.horizontalCenter
                font.pixelSize: 24
            }

            // User history
            Rectangle {
                height: parent.height - 110
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
                    height: 40
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
