#include "include/remotewindow.h"
#include "include/FileListView.h"
#include "ui_remotewindow.h"

#include <QListView>

#include <iostream>

RemoteWindow::RemoteWindow(QWidget *parent)
    : QDialog(parent)
    , ui(new Ui::RemoteWindow)
{
    ui->setupUi(this);
    FileListView *listView = ui->centralwidget->findChild<FileListView *>("listView");
    listView->setModel(&m_model);
}

RemoteWindow::~RemoteWindow()
{
    delete ui;
}

void RemoteWindow::on_usernameBox_textChanged(const QString &arg1)
{
    m_userName = arg1;
}

void RemoteWindow::on_machineBox_textChanged(const QString &arg1)
{
    m_machine = arg1;
}

void RemoteWindow::on_directoryBox_textChanged(const QString &arg1)
{
    m_directory = arg1;
}

void RemoteWindow::on_pushButton_pressed()
{
    m_model.launchUpdate(m_userName, m_machine, m_directory);
}

void RemoteWindow::on_selectButton_clicked()
{
    if(m_selected_index != nullptr)
        m_model.select(m_userName, m_machine, m_directory, *m_selected_index);
}

void RemoteWindow::on_listView_clicked(const QModelIndex &index)
{
    m_selected_index = &index;
}

