/**
  * OneMoreSamegame
  * http://www.samegame.saiko.cz/
  * (c) 2014 Dušan Saiko dusan.saiko@gmail
  * Apache License 2.0
  */
Qt.include("global.js")

/**
  * Functions for application status bar, level and score display
  *
  * code signoff date: 2014-08-15
  */

//array of score digits
var digits = []

function init() {
    //load digits[] array
    for(var i=0; i<children.length; i++) {
        if(children[i].objectName === "ScoreDigit")
            digits.push(children[i])
    }

    resetScore()
}

function displayLevel() {
    var n = level
    if(n > 99) n = 99
    if(n < 1) n = 1

    digit1.source = Global.spritePath+"level_"+Math.floor(n / 10)+".png"
    digit2.source = Global.spritePath+"level_"+Math.floor(n % 10)+".png"
}

function resetScore() {
    totalScore = 0
    addScore(0, 1)
}


function addScore(count, numberOfColors) {

    if(count > 0) {
        //formula for total score
        totalScore += Math.pow(count - 1, 2) * (numberOfColors - 1)
    }

    var n = number_format(totalScore);

    var d = 0;
    for(var i = n.length - 1; i>=0; i--) {
        var digit = digits[d ++];

        if(n[i] === ",") {
            digit.source = digitsPath+"_.png"
        } else {
            digit.source = digitsPath + n[i] + ".png"
        }
    }

    while(d < digits.length) {
            digits[d ++].source = digitsPath+"-.png"
    }
}

