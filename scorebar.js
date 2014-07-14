
Qt.include("global.js")

var digits = [];

var totalScore = 0;
var lastAdition = 0;
var numberofDigits = 60;


function resize() {
    var cx = scoreBar.height * 200 / 314;

    for(var i=0; i<digits.length; i++) {
        var digit = digits[i];
        digit.x = scoreBar.width - ((i+1) * cx)
        digit.y = 0;
        digit.width = cx
        digit.height = height
    }
}


function create() {
    var component = Qt.createComponent("Digit.qml");

    for(var i=0; i < numberofDigits; i++) {
        var digit = component.createObject(scoreBar);
        digits.push(digit)
    }

    addScore(0, 1);
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
