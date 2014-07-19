#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QIcon>
#include <QWindow>

#include "platform-details.h"

/**
 * TODO: select proper number of pieces on startup, allow changing number of pieces, saving layout and settings
 * TODO: counter - keep aspect ratio
 * TODO: animation, settings
 * TODO: performance, test fullscreen 75*50
 * TODO: sound
 * TODO: beautifull the code, licence etc
 * TODO: android deployment + android layouts
 * TODO: onMouseOut
 * TODO: FullScreen
 * TODO: resize, mobile resize, mobile layout for 20x15s
 * TODO: Window icon?!
 */

Q_DECL_EXPORT int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    PlatformDetails platformDetails(&app);

    QQmlApplicationEngine engine;
    engine.rootContext()->setContextProperty("PlatformDetails", &platformDetails);
    engine.load(QUrl(QStringLiteral("qrc:///main.qml")));

    QWindowList windowList = QGuiApplication::topLevelWindows();

    QIcon icon(":/icon.png");
    for (int i = 0; i < windowList.size(); ++i) {
        QWindow *w = windowList.at(i);
        w->setIcon(icon);
        //qDebug() << "Window: " << w->title();
    }

    return app.exec();
}

