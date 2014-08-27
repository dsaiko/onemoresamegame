/**
  * OneMoreSamegame
  * http://www.samegame.saiko.cz/
  * (c) 2014 Dušan Saiko dusan.saiko@gmail
  * Apache License 2.0
  */
#ifndef PLATFORMDETAILS_H
#define PLATFORMDETAILS_H

#include <QObject>
#include <QGuiApplication>
#include <QSettings>

class PlatformDetails : public QObject
{
    Q_OBJECT

public:

    #define APP_BUILD_VERSION "0.9.11"

    PlatformDetails(QObject *parent) :QObject(parent), settings("OneMoreSamegame", "onemoresamegame")
    {
    }


    Q_PROPERTY(bool     isMobile                READ isMobile               CONSTANT)
    Q_PROPERTY(QString  buildDate               READ buildDate              CONSTANT)
    Q_PROPERTY(QString  osType                  READ osType                 CONSTANT)
    Q_PROPERTY(QString  osVersion               READ osVersion              CONSTANT)
    Q_PROPERTY(QString  appVersion              READ appVersion             CONSTANT)
    Q_PROPERTY(bool     isMouseButtonPressed    READ isMouseButtonPressed)

    Q_INVOKABLE void saveValue(const QString & key, const QVariant & value) {
        settings.setValue(key, value);
    }

    Q_INVOKABLE QVariant loadValue(const QString &key, const QVariant &defaultValue = QVariant()) const {
        return settings.value(key, defaultValue);
    }


    bool isMobile();
    QString osType();
    QString osVersion();

    QString buildDate() {
        return __DATE__ " " __TIME__;
    }


    QString appVersion() {
        return APP_BUILD_VERSION;
    }

    bool isMouseButtonPressed() {
        Qt::MouseButtons buttons = QGuiApplication::mouseButtons();
        if(buttons == Qt::NoButton) {
            return false;
        }
        return true;
    }

private:
    QSettings settings;
};
#endif // PLATFORMDETAILS_H
