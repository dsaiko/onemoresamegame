#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>

#include "platform-details.h"

/**
 * TODO: select proper number of pieces on startup, allow changing number of pieces, saving layout and settings
 * TODO: counter - keep aspect ratio
 * TODO: animation, settings
 * TODO: performance, test fullscreen 75*50
 * TODO: sound
 * TODO: beautifull the code, licence etc
 * TODO: click - finger tap - animation - another - destroy
  */

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    PlatformDetails platformDetails;

    QQmlApplicationEngine engine;
    engine.rootContext()->setContextProperty("PlatformDetails", &platformDetails);

    engine.load(QUrl(QStringLiteral("qrc:///main.qml")));

    return app.exec();
}
