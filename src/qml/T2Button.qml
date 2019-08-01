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
        border.width: 2
        border.color: mArea.containsMouse ? "#3f51b5" : "#aaaaaa"
        anchors.fill: parent
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
