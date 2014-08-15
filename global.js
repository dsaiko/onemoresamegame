/**
  * OneMoreSamegame
  * http://www.samegame.saiko.cz/
  * (c) 2014 Dušan Saiko dusan.saiko@gmail
  * Apache License 2.0
  */
.pragma library


/**
  * Global functions
  *
  * code signoff date: 2014-08-15
  */

var digitsPath = "/images/sprites/digit-";
var spritePath = "/images/sprites/";

//http://stackoverflow.com/questions/2450954/how-to-randomize-shuffle-a-javascript-array
function shuffle(array) {
  var currentIndex = array.length
    , temporaryValue
    , randomIndex;

  // While there remain elements to shuffle...
  while (0 !== currentIndex) {

    // Pick a remaining element...
    randomIndex = Math.floor(Math.random() * currentIndex);
    currentIndex -= 1;

    // And swap it with the current element.
    temporaryValue = array[currentIndex];
    array[currentIndex] = array[randomIndex];
    array[randomIndex] = temporaryValue;
  }

  return array;
}

function generateRandomArray(size) {
    var array = []

    for(var i=0; i<size; i++)
        array.push(Math.random())

    return array
}

function generateRoomNumber_() {
    //4 groups of 3 letters separated by dash
    //rules: no digit can repeat in a group
    //if group starts with odd digit it needs to end with even and vice versa
    //group needs to be unique

    var number = "";

    for(var i=0; i<4; i++) {
        var group = ""
        var digits = [0,1,2,3,4,5,6,7,8,9]

        for(var i2 = 0; i2 < 3; i2 ++) {
            var index = Math.floor(Math.random() * digits.length)

            var digit = digits[index];
            digits.splice(index, 1)

            group += digit

            if(i2 == 1) {
                //prepare for last digit
                for(var n = digits.length - 1; n >= 0; n--) {
                    if(digits[n] % 2 === group[0] % 2) {
                        digits.splice(n, 1)
                    }
                }
            }
        }

        if(number.indexOf(group) == -1) {
            number += group
            if(i < 3) number += "-"
        } else {
            i--;
        }
    }

    return number;
}

function generateRoomNumber() {

    //just to be sure we generate valid numbers
    while(true) {
        var number = generateRoomNumber_();
        if(validateRoomNumber(number)) return number;
    }
}

function validateRoomNumber(number) {
    if(! /^([0-9]{3}-[0-9]{3}-[0-9]{3}-[0-9]{3})$/.test(number)) return false;


    var reg = new RegExp(/[0-9]{3}/g);
    var result;
    var wholeNumber = ""

    while((result = reg.exec(number)) !== null) {
        var group = result[0]
        if(wholeNumber.indexOf(group) != -1) return false;
        wholeNumber += group + "-"

        if(group[0] % 2 === group[2] % 2) return false;
    }

    return true;

}
