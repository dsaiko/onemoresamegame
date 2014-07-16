import QtQuick 2.3

import "global.js" as Global


Item {

    property int level: 0

    Image {
        id: levelLabel
        source: Global.spritePath+"level.png";
        x: 0;
        y: 0;
        height: scoreBar.height;
        mipmap: true
        fillMode: Image.PreserveAspectFit
        visible:  true;
    }


    Image {
        id: digit1

        source: Global.spritePath+"level_0.png";
        x: levelLabel.width;
        y: 0;
        height: scoreBar.height;
        mipmap: true
        fillMode: Image.PreserveAspectFit
    }

    Image {
        id: digit1b

        source: Global.spritePath+"level_0.png";
        x: levelLabel.width;
        y: 0;
        height: scoreBar.height;
        mipmap: true
        fillMode: Image.PreserveAspectFit

        onSourceChanged: {
            y = -scoreBar.height;
            digit1Animation.start();
        }

        SequentialAnimation {
            id: digit1Animation

            ParallelAnimation {
                PropertyAnimation {
                    target: digit1b
                    property: "y"
                    to: 0
                    duration: 150
                }
                PropertyAnimation {
                    target: digit1
                    property: "y"
                    to: scoreBar.height
                    duration: 150
                }
            }
            ScriptAction {
                script: {
                    digit1.source = digit1b.source;
                    digit1.y = 0;
                }
            }
        }
    }

    Image {
        id: digit2
        source: Global.spritePath+"level_1.png";
        x: levelLabel.width + digit1.width;
        y: 0;
        height: scoreBar.height;
        mipmap: true
        fillMode: Image.PreserveAspectFit
    }

    Image {
        id: digit2b
        source: Global.spritePath+"level_1.png";
        x: levelLabel.width + digit1.width;
        y: 0;
        height: scoreBar.height;
        mipmap: true
        fillMode: Image.PreserveAspectFit

        onSourceChanged: {
            y = -scoreBar.height;
            digit2Animation.start();
        }

        SequentialAnimation {
            id: digit2Animation

            ParallelAnimation {
                PropertyAnimation {
                    target: digit2b
                    property: "y"
                    to: 0
                    duration: 150
                }
                PropertyAnimation {
                    target: digit2
                    property: "y"
                    to: scoreBar.height
                    duration: 150
                }
            }
            ScriptAction {
                script: {
                    digit2.source = digit2b.source;
                    digit2.y = 0;
                }
            }
        }
    }

    onLevelChanged: {
        var n = level;
        if(n > 99) n = 99;
        if(n < 1) n = 1;

        digit1b.source = Global.spritePath+"level_"+Math.floor(n / 10)+".png";
        digit2b.source = Global.spritePath+"level_"+Math.floor(n % 10)+".png";
    }
}
