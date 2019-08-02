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
import QtQuick.Dialogs 1.2
import QtQuick.Controls 2.12

import trying.io.typing 0.2

Window {
    id: mainWindow
    visible: true
    minimumHeight: 700
    minimumWidth: 1150
    width: 1150
    height: 700
    title: qsTr(Qt.application.name)

    // To close the Application.
    function exit () {
        Qt.quit();
    }

    // Shortcut to call exit function.
    Shortcut {
        autoRepeat: false
        sequence: "Esc"
        onActivated: {
            exit();
        }
    }

    Image {
        anchors.fill: parent
        source: "qrc:/image/background.png"
    }

    Typing {
        id: typing
    }

    Row {
        anchors.fill: parent
        Rectangle {
            id: leftBar
            width: 230
            height: parent.height
            color: "#d9ffffff"
            property int currentIndex;
            Rectangle {
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 0
                anchors.top: parent.top
                anchors.topMargin: 0
                width: 2
                border.width: 0;
                color: "#3f51b5"
                anchors.right: parent.right
                anchors.rightMargin: 0
            }

            ScrollView {
                anchors.fill: parent
                clip: true

                Item {
                    Column {
                        spacing: 8
                        anchors.fill: parent

                        TButton {
                            id: welcomePageButton
                            height: 50
                            width: 230
                            text: "Welcome"
                            onClicked: {
                                swipeView1.setCurrentIndex(0);
                            }
                        }

                        TButton {
                            id: uploadSourceCodeButton
                            height: 50
                            width: 230
                            text: "Upload Source Code"
                            onClicked: {
                                uploadSourceCodePage.init();
                                swipeView1.setCurrentIndex(1);
                            }
                        }

                        TButton {
                            id: practiceButton
                            height: 50
                            width: 230
                            text: "Practice!"
                            onClicked: {
                                practiceAndResultPage.init();
                                swipeView1.setCurrentIndex(2);
                            }
                        }

                        TButton {
                            id: historyButton
                            height: 50
                            width: 230
                            text: "History"
                            onClicked: {
                                historyPage.init();
                                swipeView1.setCurrentIndex(3);
                            }
                        }

                        TButton {
                            id: exiTButton
                            height: 50
                            width: 230
                            text: "Exit"
                            onClicked: {
                                exit();
                            }
                        }
                    }
                }
            }
        }

        SwipeView {
            id:swipeView1
            width: parent.width - leftBar.width
            height: parent.height
            orientation: Qt.Vertical
            interactive: false
            currentIndex: 0
            clip: true

            WelcomePage {
                id: welcomePage
            }

            UploadSourceCodePage {
                id: uploadSourceCodePage
                mainWindow: mainWindow
                typing: typing
            }

            PracticeAndResultPage {
                id: practiceAndResultPage
                mainWindow: mainWindow
                typing: typing
            }

            HistoryPage {
                id: historyPage
                mainWindow: mainWindow
            }
        }
    }
}
