/* UI Trying.io
*
* This file is part of the Trying.io.
*
* Authors:
* Qusai Hroub <qusaihroub.r@gmail.com>
*
*/

import QtQuick 2.7
import QtQuick.Controls 2.5
import QtQuick.Dialogs 1.2
import QtQuick.Window 2.12

import trying.io.typing 0.2

Item {
    width: 1690
    height: 1051

    property Window mainWindow;
    property Typing typing;

    QtObject {
        id: internal

        readonly property int baseWidth: 1690
        readonly property int baseHeight: 1051

        property var language : ["c", "cpp", "java"]
    }

    function init() {
        languageComboBox.currentIndex = 0;
        editor.clear();
        fileName.clear();
    }

    function save() {
        if (fileName.text.length === 0) {
            fileNameDialog.setVisible(true);
            return;
        }
        if (editor.text.length === 0) {
            codeTextDialog.open();
            return;
        }

        typing.saveFile(fileName.text, internal.language[languageComboBox.currentIndex], editor.text);
        init();
    }

    MessageDialog {
        id: fileNameDialog
        title: "File name"
        text: "Enter valid file name"
        onAccepted: {
            close();
        }
    }

    MessageDialog {
        id: codeTextDialog
        title: "Code text"
        text: "Enter text of code"
        onAccepted: {
            close();
        }
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
                text: qsTr("Upload Source Code")
                anchors.horizontalCenter: parent.horizontalCenter
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                font.pixelSize: 24
            }

            Row {
                height: 60
                spacing: 8
                anchors.horizontalCenter: parent.horizontalCenter

                Text {
                    text: qsTr("File name: ")
                    anchors.verticalCenter: parent.verticalCenter
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                    font.pixelSize: 16
                }
                TextField {
                    id: fileName
                    anchors.verticalCenter: parent.verticalCenter
                    width: 180
                }
            }

            Row {
                height: 60
                spacing: 8
                anchors.horizontalCenter: parent.horizontalCenter

                Text {
                    text: qsTr("Language: ")
                    anchors.verticalCenter: parent.verticalCenter
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                    font.pixelSize: 16
                }
                ComboBox {
                    id: languageComboBox
                    width: 180
                    focusPolicy: Qt.TabFocus
                    spacing: 0
                    anchors.verticalCenter: parent.verticalCenter
                    model: ListModel {
                        ListElement {
                            text: "C";
                        }
                        ListElement {
                            text: "C++";
                        }
                        ListElement {
                            text: "Java"
                        }
                    }
                }
            }

            Rectangle {
                height: parent.height - 260
                color: "#00000000"
                anchors.horizontalCenter: parent.horizontalCenter
                border.color: "#3f51b5"
                border.width: 2
                width: parent.width - parent.width * 0.16
                Flickable {
                    id: flickable
                    anchors.fill: parent
                    clip: true

                    TextArea.flickable: TextArea {
                        id: editor
                        text: qsTr("")
                        horizontalAlignment: Text.AlignLeft
                        font.pixelSize: 20
                    }

                    ScrollBar.vertical: ScrollBar { }
                    ScrollBar.horizontal: ScrollBar { }
                }
            }

            Row {
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: 16

                TButton {
                    id: saveButton
                    width: 200
                    height: 40
                    text: "save"
                    onClicked: {
                        save();
                    }
                }
            }
        }
    }
}
