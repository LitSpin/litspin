
#include <QApplication>
#include <GL/freeglut.h>

#include "src/include/voxelizer.h"
#include "include/mainwindow.h"

int main(int argc, char *argv[])
{
    if(argc == 2)
        Voxelizer::voxelize(argv[1]);
    QApplication a(argc, argv);
    MainWindow w;
    w.show();

    return a.exec();
}
