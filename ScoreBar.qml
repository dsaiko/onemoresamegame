import QtQuick 2.0


import "scorebar.js" as ScoreBar

import "global.js" as Global

Item {
    id: scoreBar;

    signal scoreAdded(int count)
    signal doubleScore

    onWidthChanged:         ScoreBar.resize();
    onHeightChanged:        ScoreBar.resize();

    Component.onCompleted:  ScoreBar.create();

    onDoubleScore:          ScoreBar.doubleScore();
    onScoreAdded:           ScoreBar.addScore(count);
}
