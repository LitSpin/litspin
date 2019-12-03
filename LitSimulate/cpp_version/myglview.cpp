#include "myglview.h"
#include <GL/glu.h>
#include <GL/glut.h>
#include <QString>
#include <cmath>

MyGLView::MyGLView(QWidget * parent) : QOpenGLWidget(parent), camera(glm::vec3(0, 0, h/2))
{
    connect(parent->parentWidget(), SIGNAL(file_transmit(QString)), this, SLOT(get_file(QString)));
    connect(parent->parentWidget(), SIGNAL(new_h(int)), this, SLOT(h_changed(int)));
    setFocusPolicy(Qt::StrongFocus);

    connect(&timer, SIGNAL(timeout()), this, SLOT(update()));
    timer.start(16);

    setMouseTracking(true);

    r=0;
    theta =0;
}
void MyGLView::initializeGL(){
    glClearColor(0,0,0,0);
    glEnable(GL_DEPTH_TEST);

    glMatrixMode(GL_MODELVIEW);
    glLoadIdentity();

    camera.setPosition(0,50,h/2);
    camera.update(m_width, m_height);
}

void MyGLView::paintGL()
{
    if (r!=0)
    {
        glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);

        camera.update(m_width, m_height);


        glBegin(GL_POINTS);
        glPointSize(5);
        for (int i=0; i<image.width(); i++)
        {
            for (int j=0; j<image.height(); j++)
            {
                QRgb pixel = image.pixel(i,j);
                glColor3d(double(qRed(pixel))/255.0,double(qGreen(pixel))/255.0,double(qBlue(pixel))/255.0);
                glVertex3d((r-(j/h))*cos(i*theta), (r-(j/h))*sin(i*theta), h-j%h);
            }
        }
        glEnd();
    }
}


void MyGLView::resizeGL(int w, int h)
{
    glViewport(0, 0, w, h);
    m_width = w;
    m_height = h;
}

void MyGLView::get_file(QString path){
    image.load(path);
    r = image.height()/h;

    std::cout << "Open file " << r << std::endl;

    theta = 2*M_PI/double(image.width());

    emit update();

}

void MyGLView::h_changed(int new_h){
    std::cout << h << std::endl;
    h = new_h;
    r = image.height()/h;
}



void MyGLView::keyPressEvent(QKeyEvent *event) {


    std::cout << "key press" << std::endl;


switch (event->key()) {

case Qt::Key_Q:
    camera.moveTheta(-0.1f);
    break;
case Qt::Key_D:
    camera.moveTheta(+0.1f);
    break;
case Qt::Key_Z:
    camera.movePhi(0.1f);
    break;
case Qt::Key_S:
    camera.movePhi(-0.1f);
    break;
case Qt::Key_A:
    camera.moveRadius(1.f);
    break;
case Qt::Key_E:
    camera.moveRadius(-1.f);
    break;
}
}

void MyGLView::mousePressEvent(QMouseEvent *event)
{
    if(event->buttons() & Qt::LeftButton)
    {
        prev_mouse_pos = event->pos();
    }
}

void MyGLView::mouseMoveEvent(QMouseEvent *event)
{
    if(event->buttons() & Qt::LeftButton)
    {
        auto delta = event->pos() - prev_mouse_pos;
        camera.moveTheta(-float(delta.x())/100.f);
        camera.movePhi(float(delta.y())/100.f);

        prev_mouse_pos = event->pos();
    }
}

void MyGLView::wheelEvent(QWheelEvent *event)
{
    camera.moveRadius(event->angleDelta().y()/100.f);
}




