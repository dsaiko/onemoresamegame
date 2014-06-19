#include <QGuiApplication>
#include <QQmlApplicationEngine>

/**
 * TODO: select proper number of pieces on startup, allow changing number of pieces, saving layout and settings
 * TODO: counter - keep aspect ratio
 * TODO: animation, settings
 * TODO: performance, test fullscreen 75*50
 * TODO: sound
  */

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;
    engine.load(QUrl(QStringLiteral("qrc:///main.qml")));

    return app.exec();
}
