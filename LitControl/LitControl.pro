#-------------------------------------------------
#
# Project created by QtCreator 2020-01-24T11:21:37
#
#-------------------------------------------------

QT       += core gui

greaterThan(QT_MAJOR_VERSION, 4): QT += widgets

TARGET = LitControl
TEMPLATE = app

# The following define makes your compiler emit warnings if you use
# any feature of Qt which has been marked as deprecated (the exact warnings
# depend on your compiler). Please consult the documentation of the
# deprecated API in order to know how to port your code away from it.
DEFINES += QT_DEPRECATED_WARNINGS

# You can also make your code fail to compile if you use deprecated APIs.
# In order to do so, uncomment the following line.
# You can also select to disable deprecated APIs only up to a certain version of Qt.
#DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000    # disables all the APIs deprecated before Qt 6.0.0

CONFIG += c++11

SOURCES += \
        main.cpp \
        mainwindow.cpp \
    main.cpp \
    src/objreader.cpp \
    src/voxelizer.cpp \
    src/vector3d.cpp \
    src/face.cpp \
    myglwindow.cpp \
    myglview.cpp \
    fileexplorer.cpp \
    camera.cpp

HEADERS += \
        mainwindow.h \
    src/include/voxelizer.h \
    src/include/vector3d.h \
    src/include/objreader.h \
    src/include/face.h \
    myglview.h \
    fileexplorer.h \
    camera.h

FORMS += \
        mainwindow.ui

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target
