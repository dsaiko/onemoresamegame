
Qt.include("global.js")

var digits = [];

var totalScore = 0;
var lastAdition = 0;


function resize() {
    for(var i=0; i<digits.length; i++) {
        var digit = digits[i];
        digit.x = i * (width / digits.length)
        digit.y = 0;
        digit.width = width / digits.length
        digit.height = height
    }
}


function create() {
    var component = Qt.createComponent("Digit.qml");

    for(var i=0; i < 15; i++) {
        var digit = component.createObject(scoreBar);
        digits.push(digit)
    }

    addScore(0);
}


function addScore(count) {

    lastAdition = count;
    if(lastAdition > 0) { //check overflow
        totalScore += (count - 1) * (count - 1);
    }

    var n = totalScore;
    var digitCount = 0;

    for(var i=digits.length -1; i>=0; i--) {
        var charpos = digits.length - i;
        if(digits[i]) {
            var digit = digits[i];

            if (n !== 0 && charpos % 4 === 0) {
                digit.source = digitsPath+"_.png";
            } else {
                var d = n % 10;
                if(d < 0) { //large nubmer overflow
                    d = -d;
                }

                n = Math.floor(n / 10);

                if(d === 0 && n === 0 && digitCount > 0) {
                    digit.source = digitsPath+"-.png";
                } else {
                    digit.source = digitsPath+d+".png";
                    digitCount ++;
                }
            }
        }
    }
}

function doubleScore() {
    addScore(lastAdition);
}
