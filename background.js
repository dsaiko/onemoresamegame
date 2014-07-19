function create() {
    var component = Qt.createComponent("BackgroundSprite.qml");

    for(var i=0; i < 450; i++) {
        component.createObject(background);
    }
}
