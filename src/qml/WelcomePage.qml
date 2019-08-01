/* UI Typing.io
*
* This file is part of the Typing.io.
*
* Authors:
* Qusai Hroub <qusaihroub.r@gmail.com>
*
*/

import QtQuick 2.0

Item {
    width: 1690
    height: 1051

    function exit () {
        Qt.quit();
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

        Item {
            id: element
            anchors.topMargin: 8
            anchors.fill: parent

            Text {
                text: qsTr("Welcome")
                anchors.top: parent.top
                anchors.topMargin: parent.height * 0.1
                anchors.horizontalCenter: parent.horizontalCenter
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                font.pixelSize: 24
            }

            Item  {
                id: element1
                anchors.fill: parent

                Row {
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                    spacing: parent.width * 0.015

                    T2Button {
                        id: uploadSourceCodeButton
                        height: 150
                        width: 150
                        text: "Go To Upload\nSource Code"
                        onClicked: {
                            uploadSourceCodePage.init();
                            swipeView1.setCurrentIndex(1);
                        }
                    }

                    T2Button {
                        id: practiceButton
                        height: 150
                        width: 150
                        text: "Go To\nPractice!"
                        onClicked: {
                            practiceAndResultPage.init();
                            swipeView1.setCurrentIndex(2);
                        }
                    }

                    T2Button {
                        id: exitButton
                        height: 150
                        width: 150
                        text: "Exit"
                        onClicked: {
                            exit();
                        }
                    }
                }
            }
        }
    }
}
