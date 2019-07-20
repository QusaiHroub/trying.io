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
import QtWinExtras 1.0
import typing.io 0.1

Window {
    id: window
    width: 800
    height: 800
    flags: Qt.WindowTitleHint

    property Window mainWindow;
    property Typing typing;

    function init() {
        languageComboBox.currentIndex = 0;
        editor.clear();
    }

    function exit() {
        mainWindow.show();
        hide();
    }

    function save() {
        typing.save(languageComboBox.currentText, editor.text);
        mainWindow.isSave = true;
    }

    TaskbarButton{
        visible: true
    }

    Column {
        spacing: 16
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter

        Text {
            text: qsTr("Upload Source Code")
            anchors.horizontalCenter: parent.horizontalCenter
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            font.pixelSize: 24
        }

        Row {
            height: 100
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
            height: 400
            color: "#00000000"
            border.color: "#3f51b5"
            border.width: 2
            width: 600
            ScrollView {
                id: editorScrollView
                anchors.fill: parent
                clip: true


                TextEdit {
                    id: editor
                    text: qsTr("")
                    anchors.rightMargin: 4
                    anchors.leftMargin: 4
                    anchors.bottomMargin: 4
                    anchors.topMargin: 4
                    anchors.fill: parent
                    horizontalAlignment: Text.AlignLeft
                    font.pixelSize: 20
                }
            }
        }

        Row {
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 16

            Tbutton {
                id: exitButton
                width: 100
                height: 40
                buttonText: "exit"
                onClicked: {
                    exit()
                }
            }

            Tbutton {
                id: saveButton
                width: 100
                height: 40
                buttonText: "save and exit"
                onClicked: {
                    if (editor.text.length != 0) {
                        save();
                        exit();
                    }
                }
            }
        }
    }
}
