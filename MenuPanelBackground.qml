import QtQuick 2.0

import "global.js" as Global
import "menupanel.js" as Panel

Item {

    BetterImage {
        source: Global.spritePath+"menubg_1.png"
        x: 0
        y: 0
        width: Math.min(parent.width, parent.height) / 3
        height: width
        opacity: 0.9

        preserveAspectRatio: true
    }
    BetterImage {
        source: Global.spritePath+"menubg_2.png"

        x: parent.width - width
        y: parent.height - height

        width: Math.min(parent.width, parent.height) / 3
        height: width
        opacity: 0.7

        preserveAspectRatio: true
    }

    BetterImage {
        source: Global.spritePath+"menubg_3.png"

        x: 0
        y: parent.height - height

        width: Math.min(parent.width, parent.height) / 3
        height: width
        opacity: 0.8

        preserveAspectRatio: true
    }

    BetterImage {
        source: Global.spritePath+"menubg_4.png"

        x: parent.width - width
        y: 0

        width: Math.min(parent.width, parent.height) / 3
        height: width
        opacity: 0.8

        preserveAspectRatio: true
    }
}
