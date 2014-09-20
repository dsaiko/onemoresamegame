/**
  * OneMoreSamegame
  * http://www.samegame.saiko.cz/
  * (c) 2014 Dušan Saiko dusan.saiko@gmail
  * Apache License 2.0
  */
import QtQuick 2.0
import QtQuick.Controls 1.1
import QtQuick.Controls.Styles 1.1
import QtGraphicalEffects 1.0
import QtQuick.LocalStorage 2.0 as Sql


import "global.js" as Global
import "menupanel.js" as Panel
import "board.js" as Board
import "db.js" as DB

//code signoff date: 2014-08-22

Row {
    id:                         loading
    anchors.verticalCenter:     parent.verticalCenter
    anchors.right:              parent.right
    anchors.rightMargin:        spacing
    spacing:                    parent.height * 0.3
    property bool error:        false
    property alias hideTimer:   hideTimer

    Repeater {
        model:                  3
        BetterImage {
            id:                 img
            source:             error ? Global.spritePath+"wheel_error.png" : Global.spritePath+"wheel.png"
            preferredHeight:    spacing * 2
            visible:            loading.visible

            PropertyAnimation {
                id:             animation
                property:       "rotation"
                target:         img
                loops:          Animation.Infinite
                duration:       2000
                from:           0
                to:             360
            }

            onVisibleChanged:  visible ? animation.start() : animation.stop()
        }
    }

    Timer {
        id: hideTimer
            interval: 1500;
            running: false;
            repeat: false
            onTriggered: loading.visible = false
    }
}
