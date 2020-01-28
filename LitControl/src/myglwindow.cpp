#include "myglwindow.h"
#include <GL/glut.h>

MyGLWindow::MyGLWindow() : QOpenGLWindow(){
    connect(&timer, SIGNAL(timeout()), this, SLOT(update()));
    timer.start(16);
}
void MyGLWindow::initializeGL(){
    glClearColor(0,0,0,0);
    glEnable(GL_DEPTH_TEST);
    glEnable(GL_LIGHT0);
    glEnable(GL_LIGHTING);

}
void MyGLWindow::paintGL(){
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);

    glRotatef(0.5,10,1,1);
    glColor3f(1,1,1);
    glutSolidTeapot(0.6);

}
void MyGLWindow::resizeGL(int w, int h){
    glViewport(0,0,w,h);
    glMatrixMode(GL_PROJECTION);
    glLoadIdentity();
    gluPerspective(45, GLdouble (w/h), 0.01, 100);
    glMatrixMode(GL_MODELVIEW);
    glLoadIdentity();
    gluLookAt(0,0,5, 0,0,0, 0,1,0);
}

