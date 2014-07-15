#ifndef PLATFORMDETAILS_H
#define PLATFORMDETAILS_H

#include <QObject>
#include <QGuiApplication>
#include <QSettings>

class PlatformDetails : public QObject
{
    Q_OBJECT

public:


    PlatformDetails(QObject *parent) :QObject(parent), settings("OneMoreSamegame", "onemoresamegame")
    {
    }


    Q_PROPERTY(bool isMobile READ isMobile CONSTANT)
    Q_PROPERTY(bool isMouseButtonPressed READ isMouseButtonPressed CONSTANT)

    Q_INVOKABLE void saveValue(const QString & key, const QVariant & value) {
        settings.setValue(key, value);
    }

    Q_INVOKABLE QVariant loadValue(const QString &key, const QVariant &defaultValue = QVariant()) const {
        return settings.value(key, defaultValue);
    }


    bool isMobile() {
#ifdef Q_OS_ANDROID
   return true;
#elifdef Q_OS_IOS
   return true;
#else
   return false;
#endif
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
