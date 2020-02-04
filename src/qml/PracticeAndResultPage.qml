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
import trying.io.folder 0.2

Item {
    width: 1690
    height: 1051

    property Window mainWindow;
    property Typing typing;
    property UserProgress userProgress;

    signal fin;

    QtObject {
        id: internal

        readonly property int baseWidth: 1690
        readonly property int baseHeight: 1051
        readonly property var timeDuration: [1, 2, 5, 10, 20];

        property bool isStarted: false;
        property bool isLoaded: false;
        property var tempFolders: [];
        property var folders: [];
        property var tempFiles: [];
        property var files: [];
        property var filesList: [];
        property var language : ["c", "cpp", "java"];
        property TFolder folder;
        property var stack: [];
        property var rStack: [];
    }

    Component.onCompleted: {
        internal.folder = typing.getSaveFolder();
        typing.setTimeLabel(time);
        typing.setUserSpeedLabel(userSpeed)
        userProgress = typing.getUserProgress();
    }

    function initComponets() {
        timeDurationComboBox.currentIndex = 0;
        swipeView.setCurrentIndex(0);
        internal.stack = [];
        internal.rStack = [];
        rButton.enabled = false;
        lButton.enabled = false;
    }

    function initPractice() {
        refreshTimer.stop();
        typingCode.clear();
        typing.endTimers();
        internal.isLoaded = false;
        time.text = typing.getTimeDuration();
        userSpeed.text = "0";
    }

    function init() {
        internal.folder = typing.getSaveFolder();
        languageComboBox.currentIndex = 0;
        currnetFolderPath.text = internal.folder.getFullPath();
        filter();
        initComponets();
        typing.initGlobalVarOfUserProgress();
        refreshTimer.start();
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
        refreshTimer.stop();
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
        fin();
    }

    function filter() {
        listView.currentIndex = -1;
        listView.model = 0;
        if (internal.folder == null) {
            internal.folder = typing.getSaveFolder();
        }
        internal.files = internal.folder.scanForFiles();
        internal.filesList = [];

        for (var i in internal.files) {
            if (internal.files[i].getExtension() === internal.language[languageComboBox.currentIndex]) {
                internal.filesList.push(internal.files[i]);
            }
        }

        internal.folders = internal.folder.scanForDirectories();

        for (var it in internal.folders) {
            internal.filesList.push(internal.folders[it]);
        }

        listView.model = internal.filesList.length;
    }

    function scanFolder(folder) {
        internal.stack.push(internal.folder);
        internal.rStack = [];
        internal.folder = folder;
        currnetFolderPath.text = internal.folder.getFullPath();
        filter();
        rButton.enabled = internal.stack.length > 0;
        lButton.enabled = internal.rStack.length > 0;
    }

    function rScanFolder(folder) {
        internal.stack.push(internal.folder);
        internal.rStack.pop();
        internal.folder = folder;
        currnetFolderPath.text = internal.folder.getFullPath();
        filter();
    }

    function lScanFolder(folder) {
        internal.rStack.push(internal.folder);
        internal.stack.pop();
        internal.folder = folder;
        currnetFolderPath.text = internal.folder.getFullPath();
        filter();
    }

    History {
        id: userHistory
    }

    Timer {
        id: refreshTimer
        interval: 1000
        running: true
        repeat: true
        onTriggered: {
            internal.tempFiles = internal.folder.scanForFiles();
            if (internal.tempFiles.length !== internal.files.length) {
                filter();
            } else {
                for (var i in internal.files) {
                    if (internal.files[i].getName() !== internal.tempFiles[i].getName()) {
                        filter();
                        break;
                    }
                }
            }

            internal.tempFolders = internal.folder.scanForDirectories();
            if (internal.tempFolders.length !== internal.folders.length) {
                filter();
            } else {
                for (var it in internal.folders) {
                    if (internal.folders[it].getName() !== internal.tempFolders[it].getName()) {
                        filter();
                        break;
                    }
                }
            }
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
                                    id: rButton
                                    height: parent.height
                                    width: height
                                    text: "<"
                                    enabled: false
                                    onClicked: {
                                        lScanFolder(internal.stack[internal.stack.length - 1]);
                                        enabled = internal.stack.length > 0;
                                        lButton.enabled = internal.rStack.length > 0;
                                    }
                                }

                                TButton {
                                    id: lButton
                                    height: parent.height
                                    width: height
                                    text: ">"
                                    enabled: false
                                    onClicked: {
                                        rScanFolder(internal.rStack[internal.rStack.length - 1]);
                                        enabled = internal.rStack.length > 0;
                                        rButton.enabled = internal.stack.length > 0;
                                    }
                                }

                                Item {
                                    width: 32
                                    height: parent.height
                                }

                                Text {
                                    id: currnetFolderPath
                                    text: qsTr(internal.folder.getFullPath())
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

                            delegate: T3Button {
                                width: 133
                                height: 133
                                noteColor: internal.filesList[index] instanceof TFile ? "#009688" : "#f44336";
                                text: internal.filesList !== undefined ? internal.filesList[index].getName() : "";
                                onClicked: {
                                    if (internal.filesList[index] instanceof TFolder) {
                                        scanFolder(internal.filesList[index]);
                                        return;
                                    }
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
                            id: row
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
                                readOnly: true
                                selectionColor: "#3f51b5"


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
                                            codeView.selectionColor = "red"
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
