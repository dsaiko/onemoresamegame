import QtQuick 2.3

Rectangle {

    width: rscale * parent.width / 10 + parent.width / 30
    height: width

    color: Qt.rgba(Math.random() * 0.2, Math.random() * 0.2, Math.random() * 0.2, Math.random() * 0.2)

    readonly property real rx: Math.random()
    readonly property real ry: Math.random()

    readonly property real rscale: Math.random()
}
