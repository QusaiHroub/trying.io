/* UI Trying.io
*
* This file is part of the Trying.io.
*
* Authors:
* Qusai Hroub <qusaihroub.r@gmail.com>
*
*/

import QtQuick 2.0
import QtQuick.Controls 2.5

Item {
    width: 1690
    height: 1051

    QtObject {
        id: internal

        readonly property int baseWidth: 1690
        readonly property int baseHeight: 1051
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

        Item {
            anchors.topMargin: 8
            anchors.fill: parent

            Text {
                id: pageTitle
                text: qsTr("About")
                font.bold: true
                anchors.top: parent.top
                anchors.topMargin: parent.height * 0.1
                anchors.horizontalCenter: parent.horizontalCenter
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                font.pixelSize: 24
            }

            ScrollView {
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.leftMargin: 16
                anchors.rightMargin: 16
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 16
                height: parent.height - parent.height * 0.1 - 32 - pageTitle.height
                clip: true
                onWidthChanged: {
                    aboutbase.width = width
                }

                Column {
                    id: aboutbase
                    spacing: 32
                    width: parent.width

                    Row {
                        anchors.left: parent.left
                        anchors.right: parent.right

                        Column {
                            width: (parent.width - 32) / 2
                            anchors.topMargin: 32
                            spacing: 16
                            clip: true

                            Rectangle {
                                width: parent.width / 2
                                height: width
                                border.width: 2
                                border.color: "#3f51b5"
                                color: "#d9ffffff"
                                anchors.horizontalCenter: parent.horizontalCenter

                                Image {
                                    id: appIcon
                                    anchors.rightMargin: 2
                                    anchors.leftMargin: 2
                                    anchors.bottomMargin: 2
                                    anchors.topMargin: 2
                                    anchors.fill: parent
                                    source: "qrc:/image/icon.png"
                                }
                            }
                        }

                        Column {
                            width: (parent.width - 32) / 2
                            anchors.topMargin: 32
                            spacing: 32
                            clip: true

                            Text {
                                text: qsTr("Trying.io " + Qt.application.version)
                                font.bold: true
                                wrapMode: Text.WordWrap
                                width: parent.width
                                font.pixelSize: 20
                            }

                            Text {
                                text: qsTr("Based on Qt 5.13.0\n\n" +
                                           "Authors:\nQusai Hroub <qusaihroub.r@gmail.com>\n\n" +
                                           "Support:\n<support@trying.io> It doesn't really exists ):\n\n\n" +
                                           "The program is provided AS IS with NO WARRANTY OF ANY KIND, INCLUDING THE WARRANTY OF DESIGN, MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.")
                                wrapMode: Text.WordWrap
                                width: parent.width
                                clip: true
                                verticalAlignment: Text.AlignTop
                                horizontalAlignment: Text.AlignLeft
                                font.pixelSize: 16
                            }
                        }
                    }
                }
            }
        }
    }
}
