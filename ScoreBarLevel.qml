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
        height: scoreBar.height

        marginTop: 0.05
        marginBottom: marginTop
    }

    SlidingImage {
        id: digit1

        source: Global.spritePath+"level_0.png";

        x: levelLabel.width
        y: 0

        height: scoreBar.height
        marginTop: 0.05
        marginBottom: marginTop
    }

    SlidingImage {
        id: digit2

        source: Global.spritePath+"level_1.png"

        x: levelLabel.width + digit1.width
        y: 0;

        height: scoreBar.height
        marginTop: 0.05
        marginBottom: marginTop
    }

    onLevelChanged: {
        var n = level
        if(n > 99) n = 99
        if(n < 1) n = 1

        digit1.source = Global.spritePath+"level_"+Math.floor(n / 10)+".png"
        digit2.source = Global.spritePath+"level_"+Math.floor(n % 10)+".png"
    }
}
