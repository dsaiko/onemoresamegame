/**
  * OneMoreSamegame
  * http://www.samegame.saiko.cz/
  * (c) 2014 Dušan Saiko dusan.saiko@gmail
  * Apache License 2.0
  */

Qt.include("global.js")

var digits = [];

var lastAdition = 0;
var numberofDigits = 60;


function resetScore() {
    totalScore = 0;
    addScore(0, 1);
}


function create() {
    var component = Qt.createComponent("Digit.qml");

    for(var i=0; i < numberofDigits; i++) {
        var digit = component.createObject(scoreBar);
        digit.position = i
        digits.push(digit)
    }

    resetScore();
}


function addScore(count, numberOfColors) {

    lastAdition = count;
    if(count > 0) { //check overflow
        totalScore += Math.pow(count - 1, numberOfColors - 1);
    }

    var n = totalScore;

    for(var i=0; i < digits.length; i++) {
        var digit = digits[i];

        if(i>0 && i % 3 == 0 && n > 0) {
            digit.source = digitsPath+"_.png";
        } else {
            var d = n % 10;
            n = Math.floor(n / 10);

            if(n == 0 && d == 0 && i > 0) {
                //no more characters to print
                digit.source = digitsPath+"-.png";
            } else {
                digit.source = digitsPath+d+".png";
            }
        }


    }
}

function doubleScore() {
    addScore(lastAdition, 2);
}
