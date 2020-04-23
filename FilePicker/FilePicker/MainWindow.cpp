#include "MainWindow.h"
#include "ui_MainWindow.h"

#include <QListView>

#include <iostream>

MainWindow::MainWindow(QWidget *parent)
    : QMainWindow(parent)
    , ui(new Ui::MainWindow)
{
    ui->setupUi(this);
    FileListView *listView = ui->centralwidget->findChild<FileListView *>("listView");
    listView->setModel(&m_model);
}

MainWindow::~MainWindow()
{
    delete ui;
}

void MainWindow::on_usernameBox_textChanged(const QString &arg1)
{
    m_userName = arg1;
}

void MainWindow::on_machineBox_textChanged(const QString &arg1)
{
    m_machine = arg1;
}

void MainWindow::on_directoryBox_textChanged(const QString &arg1)
{
    m_directory = arg1;
}

void MainWindow::on_pushButton_pressed()
{
    m_model.launchUpdate(m_userName, m_machine, m_directory);
}

void MainWindow::on_selectButton_clicked()
{
    if(m_selected_index != nullptr)
        m_model.select(m_userName, m_machine, m_directory, *m_selected_index);
}

void MainWindow::on_listView_clicked(const QModelIndex &index)
{
    m_selected_index = &index;
}
