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

Window {
    width: 800
    height: 800
    title: qsTr("Typing.io")
    flags: Qt.WindowTitleHint

    property Window mainWindow;
    property Typing typing;
    property ResultsWindow resultsWindow;
    property bool isStarted: false
    property UserProgress userProgress;

    Component.onCompleted: {
        typing.setTimeLabel(time);
    }

    function init() {
        typingCode.clear();
        typing.endTimer();
        time.text = "60";
        typing.initGlobalVarOfUserProgress();
        langName.text = typing.getLnag();
        codeView.text = typing.getCodeText();
        userProgress = typing.getUserProgress();
        typing.updateUserProgress(typingCode.text);
        codeView.select(userProgress.getStartIndexOfNextWord(),
                        userProgress.getEndIndexOfNextWord());
        isStarted = false;
    }

    function start() {
        isStarted = true;
        typing.startTimer();
        userProgress.initDateAndTime();
    }

    function end() {
        typing.calcUserSpeed();
        resultsWindow.init();
        resultsWindow.show();
        typing.endTimer();
        hide();
    }

    Column {
        id: column
        spacing: 16
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter

        Text {
            text: "Practice!"
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            anchors.horizontalCenter: parent.horizontalCenter
            font.pixelSize: 24
        }

        Rectangle {
            width: parent.width
            height: 30
            color: "#00000000"
            anchors.horizontalCenter: parent.horizontalCenter

            Row {
                spacing: 4
                anchors.left: parent.left
                anchors.leftMargin: 0

                Text {
                    text: qsTr("Language: ")
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignLeft
                    font.pixelSize: 16
                }

                Text {
                    id: langName
                    text: qsTr("lang")
                    font.pixelSize: 16
                }
            }

            Row {
                spacing: 4
                anchors.right: parent.right

                Text {
                    text: qsTr("Time Remaining:")
                    font.pixelSize: 16
                }

                Text {
                    id: time
                    text: qsTr("time")
                    font.pixelSize: 16
                    onTextChanged: {
                        if (time.text === "0") {
                            end();
                        }
                    }
                }
            }
        }

        Rectangle {
            height: 250
            color: "#00000000"
            border.color: "#3f51b5"
            border.width: 0
            width: 600

            ScrollView {
                anchors.fill: parent
                clip: true

                TextEdit {
                    id: codeView
                    text: qsTr("")
                    readOnly: true
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

        Rectangle {
            height: 250
            color: "#00000000"
            border.color: "#3f51b5"
            border.width: 2
            width: 600

            ScrollView {
                anchors.fill: parent
                clip: true

                TextEdit {
                    id: typingCode
                    text: qsTr("")
                    selectionColor: "#f44336"
                    anchors.rightMargin: 4
                    anchors.leftMargin: 4
                    anchors.bottomMargin: 4
                    anchors.topMargin: 4
                    anchors.fill: parent
                    horizontalAlignment: Text.AlignLeft
                    font.pixelSize: 20


                    onTextChanged: {
                        if(!isStarted) {
                            start();
                        }
                        typing.updateUserProgress(typingCode.text);
                        if (userProgress.isEndTest()) {
                            end();
                        } else {
                            codeView.select(userProgress.getStartIndexOfNextWord(),
                                            userProgress.getEndIndexOfNextWord());
                        }
                    }
                }
            }
        }

        Row {
            anchors.horizontalCenter: parent.horizontalCenter

            Tbutton {
                id: endButton
                height: 50
                width: 120
                buttonText: "End"
                onClicked: end();
            }
        }
    }
}
