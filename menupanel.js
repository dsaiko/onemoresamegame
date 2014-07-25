Qt.include("global.js")

function onVisibleChanged(savedShape) {

    return;

    if(!visible) {
        if(menuPanel.parent && menuPanel.parent.height) {
            //at start, height is not initialized
            y = - menuPanel.parent.height;
        } else {
            y = -3000;
        }

        return;
    }

    //get random piece
    var shape = Math.floor(Math.random()*5) + 1;

    var color = Math.floor(Math.random()*5) + 1;

    var cx  = Math.min(menuPanel.width / 3, menuPanel.height / 4);
    piece.width = cx;
    piece.height = cx;
    piece.x = (menuPanel.width - cx) / 2
    piece.y = (menuPanel.height )/ 10

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
        face.x = (menuPanel.width - cx2) / 2
        face.y = piece.y + cx / 5;
    } else if (shape == 3){
        //triagnle
        var cx2 = (cx * 2) / 5;
        face.width = cx2;
        face.height = cx2;
        face.x = (menuPanel.width - cx2) / 2
        face.y = piece.y + cx / 2;
    } else if (shape == 4){
            //star
            var cx2 = (cx * 2) / 5;
            face.width = cx2;
            face.height = cx2;
            face.x = (menuPanel.width - cx2) / 2
            face.y = piece.y + cx / 3;
   }

   piece.source = spritePath+"piece_color_"+color+"_shape_"+shape+".png";
}


