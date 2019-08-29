QT  += \
    quick \
    network \
    positioning \
    concurrent \
    core

SOURCES += \
        listener.cpp \
        main.cpp \
        tasklist.cpp \
        taskmodel.cpp

RESOURCES += qml.qrc

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target

HEADERS += \
    controller.h \
    listener.h \
    tasklist.h \
    taskmodel.h
