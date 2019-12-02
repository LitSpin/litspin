#ifndef MYGLVIEW_H
#define MYGLVIEW_H

#include <QOpenGLWindow>
#include <QTimer>
#include <iostream>


class MyGLWindow : public QOpenGLWindow
{
    Q_OBJECT
public:
    explicit MyGLWindow();

protected:
    void initializeGL();
    void paintGL();
    void resizeGL(int w, int h);

private:
    QTimer timer;

};

#endif // MYGLVIEW_H
