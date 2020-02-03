
#include <GL/glu.h>
#include <GL/glut.h>
#include <QString>
#include <QMessageBox>
#include <cmath>
#include <QThread>
#include <fstream>
#include <opencv2/imgproc/types_c.h>
#include <opencv2/videoio/legacy/constants_c.h>
#include "include/imagevoxelizer.h"
#include "include/videovoxelizer.h"
#include "include/myglview.h"

#define DELTA_VOXEL_Z 0.3
#define DELTA_VOXEL_R 0.641

MyGLView::MyGLView(QWidget * parent) : QOpenGLWidget(parent), camera(glm::vec3(0, 0, DELTA_VOXEL_Z * h/2))
{
    std::cerr << parent->parentWidget()->accessibleName().toStdString() << std::endl;
    connect(parent->parentWidget(), SIGNAL(file_choice()), this, SLOT(file_explore()));
    connect(parent->parentWidget(), SIGNAL(file_transmit(QString)), this, SLOT(get_file(QString)));
    connect(parent->parentWidget(), SIGNAL(new_h(int)), this, SLOT(h_changed(int)));
    connect(parent->parentWidget(), SIGNAL(mode_changed(int)), this, SLOT(change_mode(int)));
    connect(parent->parentWidget(), SIGNAL(fps_changed(int)), this, SLOT(change_fps(int)));
    connect(parent->parentWidget(), SIGNAL(center_mode_set(int)), this, SLOT(change_center_mode(int)));
    connect(parent->parentWidget(), SIGNAL(resize_mode_set(int)), this, SLOT(change_resize_mode(int)));
    setFocusPolicy(Qt::StrongFocus);

    connect(&timer_gl, SIGNAL(timeout()), this, SLOT(update()));
    connect(&timer_frame, SIGNAL(timeout()), this, SLOT(next_frame()));

    setMouseTracking(true);

    r=0;
    theta =0;
}
void MyGLView::initializeGL(){
    glClearColor(0,0,0,0);
    glEnable(GL_DEPTH_TEST);

    glMatrixMode(GL_MODELVIEW);
    glLoadIdentity();

    camera.setPosition(0,50*float(DELTA_VOXEL_R),float(DELTA_VOXEL_Z) * h/2);
    camera.update(m_width, m_height);
}

void MyGLView::paintGL()
{
    if (r!=0)
    {
        glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);

        camera.update(m_width, m_height);

        glBegin(GL_POINTS);
        glPointSize(1);
        for (int i=0; i<image.width(); i++)
        {
            for (int j=0; j<image.height(); j++)
            {
                QRgb pixel = image.pixel(i,j);
                if (qRed(pixel)!=0 || qBlue(pixel)!=0 || qGreen(pixel)!=0){
                    glColor3d(double(qRed(pixel))/255.0,double(qGreen(pixel))/255.0,double(qBlue(pixel))/255.0);
                    glVertex3d(DELTA_VOXEL_R*(r-(j/h)-0.5)*cos(i*theta), DELTA_VOXEL_R*(r-(j/h)-0.5)*sin(i*theta), (h-j%h)*DELTA_VOXEL_Z);
                }
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

void MyGLView::file_explore(){
    timer_gl.stop();
    timer_frame.stop();
}

void MyGLView::get_file(QString path){
    QString file = path;
    if (mode == IMAGE_MODE){
        if(file.right(4) == ".obj"){
            file.chop(4);
            if(ImageVoxelizer::voxelize(file.toStdString(), center, resize)==1){
                QMessageBox msgBox;
                msgBox.setText("The given obj file does not fit in the boundaries. The object will be cut to fit.\nTo make the object fit, click the resize box");
                msgBox.exec();
            }
            file.append(".ppm");
        }
        image.load(file);
        r = image.height()/h;
        theta = 2*M_PI/double(image.width());
    }
    else {
        if(file.endsWith(".obj")){
            file.chop(4);
            file.append(".ppm");
            QMessageBox msgBox0;
            msgBox0.setText("Voxelizing a video may take a few minutes. it will be automatically displayed when voxelizing is done.");
            msgBox0.exec();
            if(VideoVoxelizer::voxelize(path.chopped(path.size()-path.lastIndexOf("/")).toStdString(), center, resize)){
                QMessageBox msgBox;
                msgBox.setText("The given video does not fit in the boundaries. The video will be cut to fit.\nTo make the object fit, click the resize box");
                msgBox.exec();
            }
        }
        getFramesFromFolder(file);
        r = frames[0].height()/h;
        theta = 2*M_PI/double(frames[0].width());
        video_display_index = 0;
        timer_frame.start(100);
    }
    timer_gl.start(33);

}

void MyGLView::h_changed(int new_h){
    h = new_h;
    r = image.height()/h;
}

void MyGLView::change_mode(int m){
    mode = m;
    r = 0;
}

void MyGLView::change_center_mode(int mode){
    center = mode;
}

void MyGLView::change_resize_mode(int mode){
    resize = mode;
}

void MyGLView::next_frame(){
    video_display_index++;
    video_display_index %= frames.size();
    image = frames[video_display_index];
}

void MyGLView::change_fps(int fps){
    timer_frame.setInterval(int(1000.0f/float(fps)));
}

void MyGLView::keyPressEvent(QKeyEvent *event) {


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

/**
 * Method taken from: https://stackoverflow.com/questions/17127762/cvmat-to-qimage-and-back
 */

QImage Mat2QImage(cv::Mat const& src)
{
    cv::Mat temp; // make the same cv::Mat
    cvtColor(src, temp,CV_BGR2RGB); // cvtColor Makes a copt, that what i need
    QImage dest((const uchar *) temp.data, temp.cols, temp.rows, temp.step, QImage::Format_RGB888);
    dest.bits(); // enforce deep copy, see documentation
    // of QImage::QImage ( const uchar * data, int width, int height, Format format )
    return dest;
}

/**
  * Method taken from: https://gist.github.com/itsrifat/66b253db2736b23f247c
  */
void MyGLView::extract_frames(const std::string &videoFilePath){

    try{
        //open the video file
        cv::VideoCapture cap(videoFilePath); // open the video file
        if(!cap.isOpened())  // check if we succeeded
            CV_Error(CV_StsError, "Can not open Video file");

        frames = std::vector<QImage>();

        //cap.get(CV_CAP_PROP_FRAME_COUNT) contains the number of frames in the video;
        for(int frameNum = 0; frameNum < cap.get(CV_CAP_PROP_FRAME_COUNT);frameNum++)
        {
            cv::Mat frame;
            cap >> frame; // get the next frame from video
            frames.push_back(Mat2QImage(frame));
        }
    }
    catch( cv::Exception& e ){
        std::cerr << e.msg << std::endl;
        exit(1);
    }
}

void MyGLView::getFramesFromFolder(QString firstFrame){
    QString framePath = firstFrame;
    std::string curr_path = firstFrame.toStdString();
    int i = stoi(framePath.chopped(4).right(6).toStdString());
    frames = std::vector<QImage>();
    std::ifstream infile (curr_path);
    std::string int_string;
    std::stringstream ss;
    while(infile.is_open()){
        frames.push_back(QImage(framePath));
        ss<<std::setw(6) << std::setfill('0') << ++i;
        int_string = ss.str();
        ss.clear();
        ss.str(std::string());
        framePath.chop(10);
        framePath.append((int_string + ".ppm").c_str());
        curr_path = framePath.toStdString();
        infile = std::ifstream(curr_path);
    }

}

