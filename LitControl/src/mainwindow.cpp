#include "include/mainwindow.h"
#include "ui_mainwindow.h"
#include "include/remotewindow.h"

MainWindow::MainWindow(QWidget *parent) :
    QMainWindow(parent),
    ui(new Ui::MainWindow)
{
    std::cout << "here" << std::endl;
    ui->setupUi(this);
    std::cout << "ui setup" << std::endl;

    QPushButton * fileExplorer = this->findChild<QWidget *>()->findChild<FileExplorer *>();
    connect(fileExplorer, SIGNAL(file_chosen(QString)), this, SLOT(receive_file(QString)));
    connect(fileExplorer, SIGNAL(file_choice()), this, SLOT(file_explore()));

    //QPushButton * remoteFilePicker = this->findChild<QWidget *>()->findChild<RemoteFileButton *>();
    //connect(remoteFilePicker, SIGNAL(clicked()), this, SLOT(open_remote()));
}

MainWindow::~MainWindow()
{
    delete ui;
}

void MainWindow::receive_file(QString file){
    emit file_transmit(file);
}

void MainWindow::h_changed(int h){
    emit new_h(h);
}

void MainWindow::file_explore(){
    emit file_choice();
}

void MainWindow::change_mode(int mode){
    emit mode_changed(mode);
}

void MainWindow::change_fps(int fps){
    emit fps_changed(fps);
}

void MainWindow::center_mode(int mode)
{
    emit center_mode_set(mode);
}

void MainWindow::resize_mode(int mode)
{
    emit resize_mode_set(mode);
}

void MainWindow::on_pushButton_3_clicked()
{
    std::cerr << "button pushed" << std::endl;
    RemoteWindow * w = new RemoteWindow(this);
    std::cerr << "remote windowd created" << std::endl;
    w->show();
}
