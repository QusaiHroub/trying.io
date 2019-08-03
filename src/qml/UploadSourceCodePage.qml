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
import trying.io.file 0.2

Item {
    width: 1690
    height: 1051

    property Window mainWindow;
    property Typing typing;

    QtObject {
        id: internal

        readonly property int baseWidth: 1690
        readonly property int baseHeight: 1051

        property string currentPath;
        property var tempFiles: [];
        property var folderList: [];
        property var language : ["c", "cpp", "java"]
    }

    function init() {
        swipeView.setCurrentIndex(0);
        if (editor.text !== "") {
            unsaveCodeDialog.open();
        } else {
            initComponent();
        }

        refreshTimer.start();
    }

    function initSaveAs() {
        internal.currentPath = typing.getSavePath();
        currnetFolderPath.text = internal.currentPath;
        file.initFile("", "", internal.currentPath, false);
        refresh();
    }

    function initComponent() {
        swipeView.setCurrentIndex(0);
        languageComboBox.currentIndex = 0;
        editor.clear();
        fileName.clear();
    }

    function save() {
        if (fileName.text.length === 0) {
            fileNameDialog.setVisible(true);
            return;
        }

        typing.saveFile(fileName.text, internal.language[languageComboBox.currentIndex], editor.text);
        initComponent();
        refreshTimer.stop();
    }

    function refresh() {
        listView.currentIndex = -1;
        listView.model = 0;
        internal.folderList = file.scanForDirectories();
        listView.model = internal.folderList.length;
    }

    File {
        id: file
    }

    Timer {
        id: refreshTimer
        interval: 1000
        running: true
        repeat: true
        onTriggered: {
            internal.tempFiles = file.scanForDirectories();
            if (internal.tempFiles.length !== internal.folderList.length) {
                refresh();
            } else {
                for (var i in internal.files) {
                    if (internal.files[i].getName() !== internal.tempFiles[i].getName()) {
                        refresh();
                        break;
                    }
                }
            }
        }
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

    MessageDialog {
        id: unsaveCodeDialog
        title: "Unsaved code"
        text: "You have unsaved code, Do you want to save or discard them."
        standardButtons: StandardButton.Save | StandardButton.Discard
        onDiscard: {
            initComponent()
        }
        onAccepted: {
            swipeView.setCurrentIndex(1);
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
                        text: qsTr("Upload Source Code")
                        font.bold: true
                        anchors.horizontalCenter: parent.horizontalCenter
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignHCenter
                        font.pixelSize: 24
                    }



                    Rectangle {
                        height: parent.height - 110
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
                            id: saveAsButton
                            width: 200
                            height: 40
                            text: "save as"
                            onClicked: {
                                if (editor.text.length === 0) {
                                    codeTextDialog.open();
                                    return;
                                }

                                initSaveAs();
                                swipeView.setCurrentIndex(1);
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
                        text: qsTr("Save as")
                        font.bold: true
                        anchors.horizontalCenter: parent.horizontalCenter
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignHCenter
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
                            enabled: false

                            delegate: T2Button {
                                width: 133
                                height: 133
                                text: internal.folderList !== undefined ? internal.folderList[index].getName() : "";
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

                    Item {
                        height: 40
                        anchors.horizontalCenter: parent.horizontalCenter
                        width: parent.width - parent.width * 0.16

                        Row {
                            anchors.horizontalCenter: parent.horizontalCenter
                            spacing: 16
                            height: parent.height

                            TButton {
                                id: saveButton
                                width: 200
                                height: parent.height
                                text: "save"
                                onClicked: {
                                    save();
                                }
                            }

                            TButton {
                                id: createFolderButton
                                width: 200
                                height: parent.height
                                text: "Create new folder"
                                enabled: false
                                onClicked: {

                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
