#include "mainwindow.h"
#include "ui_mainwindow.h"

MainWindow::MainWindow(QWidget *parent) :
    QMainWindow(parent),
    ui(new Ui::MainWindow)
{
    ui->setupUi(this);

    QPushButton * fileExplorer = this->findChild<FileExplorer *>();
    connect(fileExplorer, SIGNAL(file_chosen(QString)), this, SLOT(receive_file(QString)));

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
