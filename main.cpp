/**
  * OneMoreSamegame
  * http://www.samegame.saiko.cz/
  * (c) 2014 Dušan Saiko dusan.saiko@gmail
  * Apache License 2.0
  */
#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QIcon>
#include <QWindow>

#include "platform-details.h"

/**
 * TODO: sound
 * TODO: android deployment + android layouts
 * TODO: resize, mobile resize, mobile layout for 20x15s
 * TODO: wikipedia: samegame
 * TODO: translation - including app launcher
 * TODO: man page?
 * TODO: ubuntu, debian, redhat/fedora
 * TODO: screenshot/DEB
 * TODO: internationalization + manpages
 * TODO: resize images
 * TODO: check two - from left bottom
 * TODO: check one - continously
 * TODO: falldown/left
 */

Q_DECL_EXPORT int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    PlatformDetails platformDetails(&app);
    QIcon icon(":/icon.png");

#if QT_VERSION >= 0x050301
    app.setWindowIcon(icon);
#endif

    QQmlApplicationEngine engine;
    engine.rootContext()->setContextProperty("PlatformDetails", &platformDetails);
    engine.load(QUrl(QStringLiteral("qrc:///main.qml")));

    //workaround for Qt 5.2 to set window icon
    QWindowList windowList = QGuiApplication::topLevelWindows();
    for (int i = 0; i < windowList.size(); ++i) {
        QWindow *w = windowList.at(i);
        w->setIcon(icon);
    }

    return app.exec();
}

