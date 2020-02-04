
#include <QApplication>
#include <GL/freeglut.h>

#include "include/videovoxelizer.h"
#include "include/mainwindow.h"

int main(int argc, char *argv[])
{
    //VideoVoxelizer::voxelize("/home/salome/Téléchargements/48-cat_rigged", 2, 2);
    QApplication a(argc, argv);
    MainWindow w;
    w.show();

    return a.exec();
}
