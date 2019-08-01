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
import QtQuick.Dialogs 1.2

import typing.io 0.2
import typing.io.userprogress 0.2
import typing.io.history 0.2
import typing.io.file 0.2

Item {
    width: 1690
    height: 1051

    property Window mainWindow;
    property Typing typing;
    property UserProgress userProgress;
    property bool isStarted: false;
    property bool isLoaded: false;
    property var files;
    property var filesList: [];
    property var language : ["c", "cpp", "java"];

    Component.onCompleted: {
        typing.setTimeLabel(time);
        typing.setUserSpeedLabel(userSpeed)
        file.initFile("", "", typing.getSavePath(), false)
        userProgress = typing.getUserProgress();
    }

    function initComponets() {
        typingCode.clear();
        typing.endTimers();
        isLoaded = false;
        time.text = "60";
        userSpeed.text = "0";
        swipeView.setCurrentIndex(0);
    }

    function init() {
        languageComboBox.currentIndex = 0;
        filter();
        initComponets();
        typing.initGlobalVarOfUserProgress();
    }

    function practice() {
        langName.text = typing.getLnag();
        codeView.text = typing.getCodeText();
        swipeView.setCurrentIndex(1);
        typing.updateUserProgress(typingCode.text);
        codeView.select(userProgress.getStartIndexOfNextWord(),
                        userProgress.getEndIndexOfNextWord());
        isStarted = false;
    }

    function repractice() {
        if (!typing.isTested()) {
            loadLastSaveDialog.open();
            return;
        }

        practice();
    }

    function load() {
        if (listView.currentIndex === -1) {
            return;
        }

        typing.setSelectedFile(filesList[listView.currentIndex]);
        typing.loadFile();
        isLoaded = true;
    }

    function start() {
        isStarted = true;
        userProgress.init();
        typing.startTimers();
    }

    function end() {
        typing.endTimers();
        typing.calcUserSpeed();
        result.text = typing.getResult();
        swipeView.setCurrentIndex(2)
    }

    function finish() {
        userHistory.loadHistory();
        userHistory.append(result.text, userProgress.getDateAndTime());
        userHistory.saveHistory();
        init();
    }

    function filter() {
        listView.currentIndex = -1;
        listView.model = 0;
        files = file.scanDir();
        filesList = [];

        for (var i in files) {
            if (files[i].getExtension() === language[languageComboBox.currentIndex]) {
                filesList.push(files[i]);
            }
        }

        listView.model = filesList.length;
    }

    File {
        id: file
    }

    History {
        id: userHistory
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

        SwipeView {
            id: swipeView
            interactive: false
            anchors.topMargin: 8
            anchors.fill: parent
            clip: true

            Item {
                Column {
                    id: column
                    width: parent.width
                    height: parent.height
                    spacing: 16

                    Text {
                        text: "Select practice text."
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        anchors.horizontalCenter: parent.horizontalCenter
                        font.pixelSize: 24
                    }

                    Row {
                        id: row
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
                            onCurrentTextChanged: {
                                filter();
                            }
                        }
                    }


                    Rectangle {
                        id: rectangle
                        height: parent.height - 250
                        color: "#00000000"
                        anchors.horizontalCenter: parent.horizontalCenter
                        border.color: "#3f51b5"
                        border.width: 2
                        width: parent.width - parent.width * 0.16

                        GridView {
                            id: listView
                            cellWidth: 142
                            cellHeight: 142
                            anchors.rightMargin: 0
                            anchors.leftMargin: 8
                            anchors.bottomMargin: 8
                            anchors.topMargin: 8
                            anchors.fill: parent
                            clip: true

                            delegate: T2Button {
                                width: 133
                                height: 133
                                text: filesList !== undefined ? filesList[index].getName() : "";
                                onClicked: {
                                    listView.currentIndex = index
                                }
                            }

                            highlight: Rectangle {
                                color: "#3f51b5"
                                border.width: 0
                            }
                        }
                    }

                    Column {
                        anchors.horizontalCenter: parent.horizontalCenter
                        spacing: 16

                        MessageDialog {
                            id: loadLastSaveDialog
                            title: "Not found"
                            text: "You have not done any practice in this session."
                            onAccepted: {
                                close();
                            }
                        }

                        MessageDialog {
                            id: selectFileDialog
                            title: "Select file"
                            text: "You Must select file first."
                            onAccepted: {
                                close();
                            }
                        }

                        TButton {
                            id: loadLastSave
                            width: 200
                            height: 40
                            text: "load last test then practice"
                            onClicked: {
                                repractice();
                            }
                        }

                        TButton {
                            id: loadFile
                            width: 200
                            height: 40
                            text: "load file then practice"
                            onClicked: {
                                load();
                                if (isLoaded) {
                                    practice();
                                } else {
                                    selectFileDialog.open();
                                }
                            }
                        }
                    }
                }
            }

            Item {
                Column {
                    width: parent.width
                    height: parent.height
                    spacing: 16

                    Text {
                        text: "Practice!"
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        anchors.horizontalCenter: parent.horizontalCenter
                        font.pixelSize: 24
                    }

                    Rectangle {
                        width: parent.width - parent.width * 0.16
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
                            anchors.horizontalCenter: parent.horizontalCenter
                            spacing: 4

                            Text {
                                text: qsTr("Your speed:")
                                font.pixelSize: 16
                            }

                            Text {
                                id: userSpeed
                                text: qsTr("0")
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
                        height: (parent.height - 180) / 2
                        color: "#00000000"
                        anchors.horizontalCenter: parent.horizontalCenter
                        border.color: "#3f51b5"
                        border.width: 0
                        width: parent.width - parent.width * 0.16

                        Flickable {
                            id: codeViewFlick
                            anchors.fill: parent
                            clip: true

                            function ensureVisible(r) {
                                if (contentX >= r.x)
                                    contentX = r.x;
                                else if (contentX+width <= r.x + r.width)
                                    contentX = r.x + r.width - width;
                                if (contentY >= r.y)
                                    contentY = r.y;
                                else if (contentY+height <= r.y + r.height)
                                    contentY = r.y + r.height - height;
                            }

                            TextEdit {
                                id: codeView
                                text: qsTr("")
                                readOnly: true
                                selectionColor: "#3f51b5"
                                anchors.rightMargin: 4
                                anchors.leftMargin: 4
                                anchors.bottomMargin: 4
                                anchors.topMargin: 4
                                anchors.fill: parent
                                horizontalAlignment: Text.AlignLeft
                                font.pixelSize: 20
                                onCursorRectangleChanged: codeViewFlick.ensureVisible(cursorRectangle)


                            }
                        }
                    }

                    Rectangle {
                        height: (parent.height - 180) / 2
                        color: "#00000000"
                        anchors.horizontalCenter: parent.horizontalCenter
                        border.color: "#3f51b5"
                        border.width: 2
                        width: parent.width - parent.width * 0.16

                        Flickable {
                            id: typingCodeFlick
                            anchors.fill: parent
                            clip: true

                            function ensureVisible(r) {
                                if (contentX >= r.x)
                                    contentX = r.x;
                                else if (contentX+width <= r.x + r.width)
                                    contentX = r.x + r.width - width;
                                if (contentY >= r.y)
                                    contentY = r.y;
                                else if (contentY+height <= r.y + r.height)
                                    contentY = r.y + r.height - height;
                            }

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

                                onCursorRectangleChanged: typingCodeFlick.ensureVisible(cursorRectangle)

                                onTextChanged: {
                                    if(!isStarted) {
                                        start();
                                    }
                                    typing.updateUserProgress(typingCode.text);
                                    if (userProgress.isEndTest()) {
                                        end();
                                    } else {
                                        if (userProgress.isUserMadeMistake()) {
                                            codeView.select(userProgress.getIndexOfFirstMistakeOfUser(),
                                                            userProgress.getIndexOfFirstMistakeOfUser() + 1);
                                        } else {
                                            codeView.select(userProgress.getStartIndexOfNextWord(),
                                                            userProgress.getEndIndexOfNextWord());
                                        }
                                    }
                                }
                            }
                        }
                    }

                    Row {
                        anchors.horizontalCenter: parent.horizontalCenter

                        TButton {
                            id: endButton
                            height: 50
                            width: 120
                            text: "End"
                            onClicked: end();
                        }
                    }
                }
            }

            Item {
                Column {
                    spacing: 16
                    width: parent.width
                    height: parent.height

                    Text {
                        text: "Your result"
                        anchors.horizontalCenter: parent.horizontalCenter
                        font.pixelSize: 24
                    }

                    // User result
                    ScrollView {
                        height: parent.height - 120
                        clip: true
                        anchors.horizontalCenter: parent.horizontalCenter

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
                    TButton {
                        anchors.horizontalCenter: parent.horizontalCenter
                        text: "finish"
                        height: 50
                        width: 120
                        onClicked: finish()
                    }
                }
            }
        }
    }
}
