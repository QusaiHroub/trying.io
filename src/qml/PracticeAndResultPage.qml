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
import QtQuick.Dialogs 1.2

import trying.io.typing 0.2
import trying.io.userprogress 0.2
import trying.io.history 0.2
import trying.io.file 0.2

Item {
    width: 1690
    height: 1051

    property Window mainWindow;
    property Typing typing;
    property UserProgress userProgress;

    QtObject {
        id: internal

        readonly property int baseWidth: 1690
        readonly property int baseHeight: 1051
        readonly property var timeDuration: [1, 2, 5, 10, 20];

        property string currentPath;
        property bool isStarted: false;
        property bool isLoaded: false;
        property var files;
        property var filesList: [];
        property var language : ["c", "cpp", "java"];
    }

    Component.onCompleted: {
        typing.setTimeLabel(time);
        typing.setUserSpeedLabel(userSpeed)
        userProgress = typing.getUserProgress();
    }

    function initComponets() {
        timeDurationComboBox.currentIndex = 0;
        swipeView.setCurrentIndex(0);
    }

    function initPractice() {
        typingCode.clear();
        typing.endTimers();
        internal.isLoaded = false;
        time.text = typing.getTimeDuration();
        userSpeed.text = "0";
    }

    function init() {
        languageComboBox.currentIndex = 0;
        internal.currentPath = typing.getSavePath();
        currnetFolderPath.text = internal.currentPath;
        file.initFile("", "", internal.currentPath, false);
        filter();
        initComponets();
        typing.initGlobalVarOfUserProgress();
    }

    function practice() {
        initPractice();
        langName.text = typing.getLnag();
        codeView.text = typing.getCodeText();
        swipeView.setCurrentIndex(1);
        typing.updateUserProgress(typingCode.text);
        codeView.select(userProgress.getStartIndexOfNextWord(),
                        userProgress.getEndIndexOfNextWord());
        internal.isStarted = false;
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

        typing.setSelectedFile(internal.filesList[listView.currentIndex]);
        typing.loadFile();
        internal.isLoaded = true;
    }

    function start() {
        internal.isStarted = true;
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
        internal.files = file.scanForFiles();
        internal.filesList = [];

        for (var i in internal.files) {
            if (internal.files[i].getExtension() === internal.language[languageComboBox.currentIndex]) {
                internal.filesList.push(internal.files[i]);
            }
        }

        internal.files = file.scanForDirectories();

        for (var it in internal.files) {
            internal.filesList.push(internal.files[it]);
        }

        listView.model = internal.filesList.length;
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
        anchors.topMargin: parent.height * 100 / internal.baseHeight
        anchors.bottom: parent.bottom
        anchors.bottomMargin: parent.height * 100 / internal.baseHeight
        anchors.left: parent.left
        anchors.leftMargin: parent.width * 200 / internal.baseWidth
        anchors.right: parent.right
        anchors.rightMargin: parent.width * 200 / internal.baseWidth

        SwipeView {
            id: swipeView
            interactive: false
            anchors.fill: parent
            clip: true

            Item {

                Column {
                    anchors.topMargin: 8
                    anchors.fill: parent
                    spacing: 16

                    Text {
                        text: "Select practice text."
                        font.bold: true
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        anchors.horizontalCenter: parent.horizontalCenter
                        font.pixelSize: 24
                    }

                    Item {
                        width: parent.width - parent.width * 0.16
                        anchors.horizontalCenter: parent.horizontalCenter
                        height: 60

                        Row {
                            height: parent.height
                            anchors.left: parent.left
                            anchors.leftMargin: 0
                            spacing: 8

                            Text {
                                text: qsTr("Time duration: ")
                                anchors.verticalCenter: parent.verticalCenter
                                verticalAlignment: Text.AlignVCenter
                                horizontalAlignment: Text.AlignHCenter
                                font.pixelSize: 16
                            }
                            ComboBox {
                                id: timeDurationComboBox
                                width: 180
                                focusPolicy: Qt.TabFocus
                                spacing: 0
                                anchors.verticalCenter: parent.verticalCenter
                                delegate: ItemDelegate {
                                    width: parent.width
                                    text: internal.timeDuration[index] + "  minute/s"
                                }
                                model: internal.timeDuration.length

                                onCurrentIndexChanged: {
                                    timeDurationComboBox.displayText =
                                            internal.timeDuration[timeDurationComboBox.currentIndex] + "  minute/s";
                                    typing.setTimeDuration(internal.timeDuration[timeDurationComboBox.currentIndex]);
                                }
                            }
                        }

                        Row {
                            height: parent.height
                            anchors.right: parent.right
                            anchors.rightMargin: 0
                            spacing: 8

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
                    }

                    Item {
                        width: parent.width - parent.width * 0.16
                        height: 60
                        anchors.horizontalCenter: parent.horizontalCenter

                        Row {
                            height: parent.height

                            Row {
                                height: parent.height

                                TButton {
                                    height: parent.height
                                    width: height
                                    text: "<"
                                    enabled: false
                                }

                                TButton {
                                    height: parent.height
                                    width: height
                                    text: ">"
                                    enabled: false
                                }

                                Item {
                                    width: 32
                                    height: parent.height
                                }

                                Text {
                                    id: currnetFolderPath
                                    text: qsTr(typing.getSavePath())
                                    wrapMode: Text.WrapAnywhere
                                    width: swipeView.width - swipeView.width * 0.16 - 180
                                    verticalAlignment: Text.AlignVCenter
                                    anchors.verticalCenter: parent.verticalCenter
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
                                text: internal.filesList !== undefined ? internal.filesList[index].getName() : "";
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

                    Row {
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
                                if (internal.isLoaded) {
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
                    anchors.topMargin: 8
                    anchors.fill: parent
                    spacing: 16

                    Text {
                        text: "Practice!"
                        font.bold: true
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

                            TextArea.flickable: TextArea {
                                id: codeView
                                text: qsTr("")
                                horizontalAlignment: Text.AlignLeft
                                font.pixelSize: 20
                            }

                            ScrollBar.vertical: ScrollBar { }
                            ScrollBar.horizontal: ScrollBar { }
                        }
                    }

                    Rectangle {
                        height: (parent.height - 170) / 2
                        color: "#00000000"
                        anchors.horizontalCenter: parent.horizontalCenter
                        border.color: "#3f51b5"
                        border.width: 2
                        width: parent.width - parent.width * 0.16

                        Flickable {
                            id: typingCodeFlick
                            anchors.fill: parent
                            clip: true

                            TextArea.flickable: TextArea {
                                id: typingCode
                                text: qsTr("")
                                horizontalAlignment: Text.AlignLeft
                                font.pixelSize: 20

                                onTextChanged: {
                                    if(!internal.isStarted) {
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

                            ScrollBar.vertical: ScrollBar { }
                            ScrollBar.horizontal: ScrollBar { }
                        }
                    }

                    Row {
                        anchors.horizontalCenter: parent.horizontalCenter

                        TButton {
                            id: endButton
                            height: 40
                            width: 200
                            text: "End"
                            onClicked: end();
                        }
                    }
                }
            }

            Item {

                Column {
                    spacing: 16
                    anchors.topMargin: 8
                    anchors.fill: parent

                    Text {
                        text: "Your result"
                        font.bold: true
                        anchors.horizontalCenter: parent.horizontalCenter
                        font.pixelSize: 24
                    }

                    // User result
                    ScrollView {
                        height: parent.height - 110
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
                        height: 40
                        width: 200
                        onClicked: finish()
                    }
                }
            }
        }
    }
}
