/**
  * OneMoreSamegame
  * http://www.samegame.saiko.cz/
  * (c) 2014 Dušan Saiko dusan.saiko@gmail
  * Apache License 2.0
  */
Qt.include("global.js")

//code signoff date: 2014-08-17
function newFaceImage() {

    //get random piece
    var shape = Math.floor(Math.random()*3) + 1;

    //skip 3 and 4 - which are triangle and star
    if(shape == 3) shape=5;
    var color = Math.floor(Math.random()*5) + 1;

    piece.source = spritePath+"piece_color_"+color+"_shape_"+shape+".png";
    piece.reComputeAspectRatio();

    var cx = piece.width

    if(type == -1){
        face.source = spritePath+"sad_face.png";
    } else {
        face.source = spritePath+"happy_face.png";
    }
    face.reComputeAspectRatio()
    face.visible = true;
}


