/**
  * OneMoreSamegame
  * http://www.samegame.saiko.cz/
  * (c) 2014 Dušan Saiko dusan.saiko@gmail
  * Apache License 2.0
  */

import QtQuick 2.0

import "global.js" as Global


Item {
    property int level: 0

    BetterImage {
        id: levelLabel
        source: Global.spritePath+"level.png"
        x: 0
        y: 0

        preferredHeight: parent.height
    }

    SlidingImage {
        id: digit1

        source: Global.spritePath+"level_0.png";

        x: levelLabel.width + scoreBar.margin /2
        y: 0

        preferredHeight: parent.height
    }

    SlidingImage {
        id: digit2

        source: Global.spritePath+"level_1.png"

        x: digit1.x + digit1.width + scoreBar.margin /2
        y: 0;

        preferredHeight: parent.height
    }

    onLevelChanged: {
        var n = level
        if(n > 99) n = 99
        if(n < 1) n = 1

        digit1.source = Global.spritePath+"level_"+Math.floor(n / 10)+".png"
        digit2.source = Global.spritePath+"level_"+Math.floor(n % 10)+".png"
    }
}
