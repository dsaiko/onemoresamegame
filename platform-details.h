#ifndef PLATFORMDETAILS_H
#define PLATFORMDETAILS_H

#include <QObject>

class PlatformDetails : public QObject
{
    Q_OBJECT

    Q_PROPERTY(bool isMobile READ isMobile CONSTANT)

public:

    bool isMobile() {
#ifdef Q_OS_ANDROID
   return true;
#elifdef Q_OS_IOS
   return true;
#else
   return false;
#endif
    }
};
#endif // PLATFORMDETAILS_H
