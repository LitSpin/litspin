
#include <QApplication>
#include <GL/freeglut.h>

#include "include/videovoxelizer.h"
#include "include/mainwindow.h"

int main(int argc, char *argv[])
{
    QApplication a(argc, argv);
    MainWindow w;
    w.show();

    return a.exec();
}
