/* UI Typing.io
*
* This file is part of the Typing.io.
*
* Authors:
* Qusai Hroub <qusaihroub.r@gmail.com>
*
*/

import QtQuick 2.7
import QtQuick.Controls 2.12

Button {

    // Button background.
    background: Rectangle {
        color: mArea.containsPress ? "#3f51b5" : "#00000000"
        border.width: 0
        border.color: "#00000000"
        anchors.fill: parent

        // The line at bottom of button.
        Rectangle {
            height: 2
            color: mArea.containsMouse ? "#3f51b5" : "#00000000"
            border.width: 0
            border.color: "#00000000"
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 0
            anchors.right: parent.right
            anchors.rightMargin: 0
            anchors.left: parent.left
            anchors.leftMargin: 0
        }
    }

    // clicked() is a signal to make connection between button onClicked event and mArea onClicked event.
    signal clicked()
    MouseArea {
        id: mArea
        anchors.fill: parent
        hoverEnabled: true
        onClicked: parent.clicked();
    }
}
