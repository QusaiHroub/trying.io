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
import QtQuick.Dialogs 1.2
import QtQuick.Controls 2.12
import typing.io 0.2

Window {
    id: mainWindow
    visible: true
    minimumHeight: 700
    minimumWidth: 1150
    width: 1150
    height: 700
    title: qsTr("Typing.io")

    property bool isSave: false;

    // To close the Application.
    function exit () {
        Qt.quit();
    }

    function loadHistory() {
        historyPage.init();
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

                Column {
                    spacing: 8
                    anchors.fill: parent

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
        }
    }
}
