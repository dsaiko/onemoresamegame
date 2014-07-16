import QtQuick 2.3


import "scorebar.js" as ScoreBar
import "global.js" as Global

Item {
    id: scoreBar;
    property alias menuButton: menuButton

    signal menuHide
    signal menuDisplay
    signal resetScore

    property int level: 0

    clip: true

    Image {
        source: "/images/digits/digit_B.png";
        anchors.fill: parent
    }

    Item {
        id: menuButton;

        z: 1
        property int type: 0;
        x: 0;
        y: 0;
        height: scoreBar.height;
        width: scoreBar.height;
        scale:0.9;

        Image {
            id: btnMenu0;
            source: Global.spritePath+"btnMenu0.png";
            x: 0;
            y: 0;
            height: scoreBar.height;
            width: scoreBar.height;
            mipmap: true
            fillMode: Image.PreserveAspectFit
            visible:  true;
        }

        Image {
            id: btnMenu1;
            source: Global.spritePath+"btnMenu1.png";
            x: 0;
            y: 0;
            height: scoreBar.height;
            width: scoreBar.height;
            mipmap: true
            fillMode: Image.PreserveAspectFit
            visible:  false;

            MouseArea {
                anchors.fill: parent

                hoverEnabled: !PlatformDetails.isMobile;
                cursorShape:  Qt.PointingHandCursor

                onClicked:  menuHide();
            }
        }

        Image {
            id: btnMenu2;
            source: Global.spritePath+"btnMenu2.png";
            x: 0;
            y: 0;
            height: scoreBar.height;
            width: scoreBar.height;
            mipmap: true
            fillMode: Image.PreserveAspectFit
            visible:  false;

            MouseArea {
                anchors.fill: parent

                hoverEnabled: !PlatformDetails.isMobile;
                cursorShape:  Qt.PointingHandCursor

                onClicked:  menuDisplay();
            }
        }

        onTypeChanged: {

            btnMenu0.visible = false;
            btnMenu1.visible = false;
            btnMenu2.visible = false;

            if(type == 1) {
                btnMenu1.visible = true;
            } else
            if(type == 2) {
                btnMenu2.visible = true;
            } else {
                btnMenu0.visible = true;
            }
        }

    }

    Level {
        id: levelPanel
        z: 1

        x: scoreBar.height;
        y: 0;

        height: scoreBar.height;
        scale:0.9;
    }


    onLevelChanged: {
        levelPanel.level = level
    }

    signal scoreAdded(int count, int numberOfColors)
    signal doubleScore

    onWidthChanged:         ScoreBar.resize();
    onHeightChanged:        ScoreBar.resize();

    Component.onCompleted:  ScoreBar.create();

    onDoubleScore:          ScoreBar.doubleScore();
    onScoreAdded:           ScoreBar.addScore(count, numberOfColors);
    onResetScore:           ScoreBar.resetScore()
}
