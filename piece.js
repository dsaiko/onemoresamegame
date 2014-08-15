/**
  * OneMoreSamegame
  * http://www.samegame.saiko.cz/
  * (c) 2014 Dušan Saiko dusan.saiko@gmail
  * Apache License 2.0
  */
Qt.include("global.js")

/**
  * Javascript functions for Piece
  *
  * code signoff date: 2014-08-15
  */

/**
  * set individual scale for each piece type
  * and shine star position
  */
function setScaleAndStarPosition() {
    switch(shape) {
        case 1: //square
            sprite.scale = 0.8
            shiningStar.x = - piece.width / 15
            shiningStar.y = 0
            break;
        case 2: //circle
            sprite.scale = 0.9
            shiningStar.x = 0
            shiningStar.y = 0
            break;
        case 3: //triangle
            sprite.scale = 0.9
            shiningStar.x = piece.width / 10
            shiningStar.y = piece.height / 6
            break;
        case 4: //star
            sprite.scale = 1
            shiningStar.x = piece.width / 8
            shiningStar.y = piece.height / 8
            break;
        case 5: //pentagon
            sprite.scale = 0.9
            break;
    }
}
