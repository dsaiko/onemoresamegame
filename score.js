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
var digits = [];

function init() {
    //load digits[] array
    for(var i=0; i<children.length; i++) {
        if(children[i].objectName === "ScoreDigit")
            digits.push(children[i])
    }

    resetScore();
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

    if(count > 0) { //check overflow
        totalScore += Math.pow(count - 1, numberOfColors)
    }

    //disaasemble total score to digits
    var n = totalScore;

    for(var i=0; i < digits.length; i++) {
        var digit = digits[i]

        if(i>0 && i % 3 == 0 && n > 0) {
            //display thousands separator
            digit.source = digitsPath+"_.png"
        } else {
            var d = n % 10
            n = Math.floor(n / 10)

            if(n == 0 && d == 0 && i > 0) {
                //no more characters to print
                digit.source = digitsPath + "-.png"
            } else {
                digit.source = digitsPath + d + ".png"
            }
        }
    }
}

