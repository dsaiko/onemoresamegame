/**
  * OneMoreSamegame
  * http://www.samegame.saiko.cz/
  * (c) 2014 Dušan Saiko dusan.saiko@gmail
  * Apache License 2.0
  */
#include <QString>
#include "platform-details.h"

QString PlatformDetails::osType() {
    #if defined(Q_OS_WINCE)
        return QByteArrayLiteral("wince");
    #elif defined(Q_OS_WIN)
        return QByteArrayLiteral("windows");

    #elif defined(Q_OS_BLACKBERRY)
        return QByteArrayLiteral("blackberry");
    #elif defined(Q_OS_QNX)
        return QByteArrayLiteral("qnx");

    #elif defined(Q_OS_ANDROID)
        return QByteArrayLiteral("android");
    #elif defined(Q_OS_LINUX)
        return QByteArrayLiteral("linux");

    #elif defined(Q_OS_IOS)
        return QByteArrayLiteral("ios");
    #elif defined(Q_OS_OSX)
        return QByteArrayLiteral("osx");
    #elif defined(Q_OS_DARWIN)
        return QByteArrayLiteral("darwin");

    #elif defined(Q_OS_FREEBSD_KERNEL)
        return QByteArrayLiteral("freebsd");
    #elif defined(Q_OS_UNIX)
        struct utsname u;
        if (uname(&u) != -1)
            return QByteArray(u.sysname).toLower();
    #endif

    return QByteArrayLiteral("unknown");
}

QString PlatformDetails::osVersion() {
    QString osFlags;

#ifdef Q_OS_AIX
 osFlags.append("Q_OS_AIX|");
#endif
#ifdef Q_OS_ANDROID
 osFlags.append("Q_OS_ANDROID|");
#endif
#ifdef Q_OS_BSD4
 osFlags.append("Q_OS_BSD4|");
#endif
#ifdef Q_OS_BSDI
 osFlags.append("Q_OS_BSDI|");
#endif
#ifdef Q_OS_CYGWIN
 osFlags.append("Q_OS_CYGWIN|");
#endif
#ifdef Q_OS_DARWIN
 osFlags.append("Q_OS_DARWIN|");
#endif
#ifdef Q_OS_DGUX
 osFlags.append("Q_OS_DGUX|");
#endif
#ifdef Q_OS_DYNIX
 osFlags.append("Q_OS_DYNIX|");
#endif
#ifdef Q_OS_FREEBSD
 osFlags.append("Q_OS_FREEBSD|");
#endif
#ifdef Q_OS_HPUX
 osFlags.append("Q_OS_HPUX|");
#endif
#ifdef Q_OS_HURD
 osFlags.append("Q_OS_HURD|");
#endif
#ifdef Q_OS_IOS
 osFlags.append("Q_OS_IOS|");
#endif
#ifdef Q_OS_IRIX
 osFlags.append("Q_OS_IRIX|");
#endif
#ifdef Q_OS_LINUX
 osFlags.append("Q_OS_LINUX|");
#endif
#ifdef Q_OS_LYNX
 osFlags.append("Q_OS_LYNX|");
#endif
#ifdef Q_OS_MAC
 osFlags.append("Q_OS_MAC|");
#endif
#ifdef Q_OS_NETBSD
 osFlags.append("Q_OS_NETBSD|");
#endif
#ifdef Q_OS_OPENBSD
 osFlags.append("Q_OS_OPENBSD|");
#endif
#ifdef Q_OS_OSF
 osFlags.append("Q_OS_OSF|");
#endif
#ifdef Q_OS_OSX
 osFlags.append("Q_OS_OSX|");
#endif
#ifdef Q_OS_QNX
 osFlags.append("Q_OS_QNX|");
#endif
#ifdef Q_OS_RELIANT
 osFlags.append("Q_OS_RELIANT|");
#endif
#ifdef Q_OS_SCO
 osFlags.append("Q_OS_SCO|");
#endif
#ifdef Q_OS_SOLARIS
 osFlags.append("Q_OS_SOLARIS|");
#endif
#ifdef Q_OS_ULTRIX
 osFlags.append("Q_OS_ULTRIX|");
#endif
#ifdef Q_OS_UNIX
 osFlags.append("Q_OS_UNIX|");
#endif
#ifdef Q_OS_UNIXWARE
 osFlags.append("Q_OS_UNIXWARE|");
#endif
#ifdef Q_OS_WIN32
 osFlags.append("Q_OS_WIN32|");
#endif
#ifdef Q_OS_WIN64
 osFlags.append("Q_OS_WIN64|");
#endif
#ifdef Q_OS_WIN
 osFlags.append("Q_OS_WIN|");
#endif
#ifdef Q_OS_WINCE
 osFlags.append("Q_OS_WINCE|");
#endif
#ifdef Q_OS_WINPHONE
 osFlags.append("Q_OS_WINPHONE|");
#endif
#ifdef Q_OS_WINRT
 osFlags.append("Q_OS_WINRT|");
#endif
#ifdef __x86_64__
 osFlags.append("__x86_64__|");
#endif
#ifdef __ppc64__
 osFlags.append("__ppc64__|");
#endif

    osFlags.chop(1);
    return osFlags;
}

