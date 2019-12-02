#ifndef MYGLVIEW_H
#define MYGLVIEW_H

#include <QOpenGLWidget>
#include <QTimer>
#include <iostream>
#include <opencv2/core/core.hpp>
#include <opencv2/highgui/highgui.hpp>
#include <cmath>
#include <camera.h>


class MyGLView : public QOpenGLWidget
{
    Q_OBJECT

public:
    explicit MyGLView(QWidget * parent = nullptr);

protected:
    void initializeGL();
    void paintGL();
    void resizeGL(int w, int h);

    void keyPressEvent(QKeyEvent *event);
    void keyReleaseEvent(QKeyEvent *event);


private:
    QImage image;
    int r,h;
    double theta;
    Camera camera;
    glm::mat4 view;
    QTimer timer;
    bool keyRight, keyLeft, keyUp, keyDown, keyShift, keyControl;
    bool keyA, keyE, keyZ, keyQ, keyS, keyD;

    void move_camera();



private slots:
    void get_file(QString path);


signals:
    void refresh();


};

#endif // MYGLVIEW_H
