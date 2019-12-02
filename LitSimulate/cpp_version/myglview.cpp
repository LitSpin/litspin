#include "myglview.h"
#include <GL/glu.h>
#include <GL/glut.h>
#include <QString>
#include <cmath>

MyGLView::MyGLView(QWidget * parent) : QOpenGLWidget(parent){
    connect(parent->parentWidget(), SIGNAL(file_transmit(QString)), this, SLOT(get_file(QString)));
    setFocusPolicy(Qt::StrongFocus);

    connect(&timer, SIGNAL(timeout()), this, SLOT(update()));
    timer.start(16);

    keyUp = false;
    keyDown = false;
    keyLeft = false;
    keyRight = false;

    keyA = false;
    keyZ = false;
    keyE = false;
    keyQ = false;
    keyS = false;
    keyD = false;
    keyShift = false;
    keyControl = false;

    r=0;
    theta =0;
    h=32;

    setMouseTracking(true);
}
void MyGLView::initializeGL(){
    glClearColor(0,0,0,0);
    glEnable(GL_DEPTH_TEST);

    glMatrixMode(GL_PROJECTION);
    glLoadIdentity();
    gluPerspective(90, 1, 0.01, 100);
    glMatrixMode(GL_MODELVIEW);
    gluLookAt(0,50,h/2,0,0,0,0,0,1);
}

void MyGLView::move_camera(){

    if(keyZ)
        glRotatef(1,1,0,0);
    if(keyS)
        glRotatef(1,-1,0,0);
    if(keyQ)
        glRotatef(1,0,1,0);
    if(keyD)
        glRotatef(1,0,-1,0);
    if(keyA)
        glRotatef(1,0,0,-1);
    if(keyE)
        glRotatef(1,0,0,1);
    if(keyUp)
        glTranslatef(0,-1,0);
    if(keyDown)
        glTranslatef(0,1,0);
    if(keyLeft)
        glTranslatef(1,0,0);
    if(keyRight)
        glTranslatef(-1,0,0);
    if(keyShift)
        glTranslatef(0,0,1);
    if(keyControl)
        glTranslatef(0,0,-1);



}

void MyGLView::paintGL(){

    if (r!=0){
        GLfloat viewmatrix[16];
        glGetFloatv(GL_MODELVIEW_MATRIX, viewmatrix);
        glLoadIdentity();
        move_camera();
        glMultMatrixf(viewmatrix);
        glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);

        glPointSize(3);
        glBegin(GL_POINTS);
            for (int i=0; i<image.width(); i++){
                for (int j=0; j<image.height(); j++){
                    QRgb pixel = image.pixel(i,j);
                    glColor3d(double(qRed(pixel))/255.0,double(qGreen(pixel))/255.0,double(qBlue(pixel))/255.0);
                    glVertex3d((r-(j/h))*cos(i*theta), (r-(j/h))*sin(i*theta), h-j%h);
                }
            }

        glEnd();
    }

}


void MyGLView::resizeGL(int w, int h){
    glViewport(0, 0, w, h);
}

void MyGLView::get_file(QString path){
    image.load(path);
    r = image.height()/h;
    theta = 2*M_PI/double(image.width());

    emit update();

}



void MyGLView::keyPressEvent(QKeyEvent *event) {

switch (event->key()) {

case Qt::Key_Q:
    keyQ = true;
    break;
case Qt::Key_D:
    keyD = true;
    break;
case Qt::Key_Z:
    keyZ = true;
    break;
case Qt::Key_S:
    keyS = true;
    break;
case Qt::Key_A:
    keyA = true;
    break;
case Qt::Key_E:
    keyE = true;
    break;
case Qt::Key_Up:
    keyUp = true;
    break;
case Qt::Key_Down:
    keyDown = true;
    break;
case Qt::Key_Left:
    keyLeft = true;
    break;
case Qt::Key_Right:
    keyRight = true;
    break;
case Qt::Key_Shift:
    keyShift = true;
    break;
case Qt::Key_Control:
    keyControl = true;
    break;

}
}

void MyGLView::keyReleaseEvent(QKeyEvent *event) {

switch (event->key()) {

case Qt::Key_Q:
    keyQ = false;
    break;
case Qt::Key_D:
    keyD = false;
    break;
case Qt::Key_Z:
    keyZ = false;
    break;
case Qt::Key_S:
    keyS = false;
    break;
case Qt::Key_A:
    keyA = false;
    break;
case Qt::Key_E:
    keyE = false;
    break;
case Qt::Key_Up:
    keyUp = false;
    break;
case Qt::Key_Down:
    keyDown = false;
    break;
case Qt::Key_Left:
    keyLeft = false;
    break;
case Qt::Key_Right:
    keyRight = false;
    break;
case Qt::Key_Shift:
    keyShift = false;
    break;
case Qt::Key_Control:
    keyControl = false;
    break;

}
}




