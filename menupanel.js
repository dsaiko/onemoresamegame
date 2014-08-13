/**
  * OneMoreSamegame
  * http://www.samegame.saiko.cz/
  * (c) 2014 Dušan Saiko dusan.saiko@gmail
  * Apache License 2.0
  */
Qt.include("global.js")

function newFaceImage() {

    //get random piece
    var shape = Math.floor(Math.random()*5) + 1;

    var color = Math.floor(Math.random()*5) + 1;

    piece.source = spritePath+"piece_color_"+color+"_shape_"+shape+".png";

    var cx = piece.width

    if(type == 1) {
        face.source = spritePath+"happy_face.png";
        face.visible = true;
    } else if(type == -1){
        face.source = spritePath+"sad_face.png";
        face.visible = true;
    } else {
        face.visible = false;
    }

    if(shape == 1 || shape == 2 || shape == 5) {
        //rectangle = 1
        //circle = 2
        //pentagon = 5
        var cx2 = (cx * 2) / 3;
        face.width = cx2;
        face.height = cx2;
        face.x = (piece.width - cx2) / 2
        face.y = cx / 5;
    } else if (shape == 3){
        //triagnle
        var cx2 = (cx * 2) / 5;
        face.width = cx2;
        face.height = cx2;
        face.x = (piece.width - cx2) / 2
        face.y = cx / 3;
    } else if (shape == 4){
            //star
            var cx2 = (cx * 2) / 5;
            face.width = cx2;
            face.height = cx2;
            face.x = (piece.width - cx2) / 2
            face.y = cx / 3;
   }

}


