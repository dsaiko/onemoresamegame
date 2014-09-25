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
#include <QDebug>
#include <QTranslator>
#include <QFile>

#include "platform-details.h"
#ifdef Q_OS_UNIX
    #include <sys/utsname.h>
#endif


Q_DECL_EXPORT int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

//    QLocale::setDefault(QLocale(QLocale::Russian, QLocale::Taiwan));

    QLocale locale;

    const QString translations[] = {
        ":/translations/translations/onemoresamegame_" + locale.name() + ".qm",
        ":/translations/translations/onemoresamegame_" + locale.name().left(2) + ".qm",
        ":/translations/translations/onemoresamegame_en.qm"
    };

    QTranslator translator;

    for(int i=0; i<2; i++) {
        QString translation = translations[i];
//qDebug() << translation;
        if(QFile(translation).exists()) {
            qDebug() << "Setting translation:" << locale.name();
            translator.load(translation);
            app.installTranslator(&translator);
            break;
        }
    }

    PlatformDetails platformDetails(&app);
    qDebug() << "One More Samegame"
             << platformDetails.appVersion()
             << platformDetails.buildDate()
             << platformDetails.osType() + "/" + platformDetails.osVersion()
             << locale.name()
    ;

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


bool PlatformDetails::isMobile() {
#if defined(Q_OS_BLACKBERRY)
    return true;
#elif defined(Q_OS_ANDROID)
    return true;
#elif defined(Q_OS_IOS)
    return true;
#endif
    return false;
}

