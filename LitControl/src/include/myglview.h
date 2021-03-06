#ifndef MYGLVIEW_H
#define MYGLVIEW_H

#include <QOpenGLWidget>
#include <QTimer>
#include <iostream>
#include <cmath>
#include <QPoint>
#include <QLineEdit>
#include <opencv2/opencv.hpp>
#include <vector>
#include <string>

#include "camera.h"

const int IMAGE_MODE = 0;
const int VIDEO_MODE = 2;

QImage Mat2QImage(cv::Mat const& src);

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
    void mousePressEvent(QMouseEvent *event);
    void mouseMoveEvent(QMouseEvent *event);
    void wheelEvent(QWheelEvent *event);

private:
    QImage image;
    int r = 0;
    int h = 32;
    int center = 0;
    int resize = 0;
    double theta;
    Camera camera;
    QTimer timer_gl;
    QTimer timer_frame;
    QPoint prev_mouse_pos;
    float m_width, m_height;
    int mode = IMAGE_MODE;
    std::vector<QImage> frames;
    unsigned long video_display_index;

    void getFramesFromFolder(QString folderName);
    void extract_frames(const std::string &videoFilePath);

private slots:
    void get_file(QString path);
    void h_changed(int h);
    void file_explore();
    void change_mode(int m);
    void next_frame();
    void change_fps(int fps);
    void change_center_mode(int mode);
    void change_resize_mode(int mode);
    void on_textButton_clicked(QLineEdit * lineEdit);

signals:
    void refresh();
    void mode_changed(int mode);


};

#endif // MYGLVIEW_H
