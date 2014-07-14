import QtQuick 2.3


import "scorebar.js" as ScoreBar

import "global.js" as Global

Item {
    id: scoreBar;

    Image {
        source: "/images/digits/digit_B.png";
        anchors.fill: parent
    }

    signal scoreAdded(int count, int numberOfColors)
    signal doubleScore

    onWidthChanged:         ScoreBar.resize();
    onHeightChanged:        ScoreBar.resize();

    Component.onCompleted:  ScoreBar.create();

    onDoubleScore:          ScoreBar.doubleScore();
    onScoreAdded:           ScoreBar.addScore(count, numberOfColors);
}
