import QtQuick 2.7
import QtQuick.Controls 2.12

T2Button {

    property string noteColor;

    Rectangle {
        width: 20
        height: width
        color: noteColor
    }
}
