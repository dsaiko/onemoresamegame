import QtQuick 2.2


import "global.js" as Global

Item {
    property int score: -1
    property var digits: []

    onScoreChanged: {
        var n = score;
        var digitCount = 0;

        for(var i=digits.length -1; i>=0; i--) {
            var charpos = digits.length - i;
            var digit = digits[i];

            if (n !== 0 && charpos % 4 === 0) {
                digit.source = Global.digitsPath+"_.png";
            } else {
                var d = n % 10;
                n = Math.floor(n / 10);

                if(d === 0 && n === 0 && digitCount > 0) {
                    digit.source = Global.digitsPath+"-.png";
                } else {
                    digit.source = Global.digitsPath+d+".png";
                    digitCount ++;
                }
            }

        }
    }


    function resize() {
        for(var i=0; i<digits.length; i++) {
            var digit = digits[i];
            digit.x = i * (width / digits.length)
            digit.y = 0;
            digit.width = width / digits.length
            digit.height = height
        }

    }

    onWidthChanged: {
        resize();
    }

    onHeightChanged:  {
        resize();
    }


    Component {
        id: digitFactory
        Digit {

        }
    }

    Component.onCompleted: {
        for(var i=0; i < 15; i++) {
            var digit = digitFactory.createObject(this);
            digits.push(digit)
        }

        score = 0
    }
}
