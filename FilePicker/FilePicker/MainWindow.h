#ifndef MAINWINDOW_H
#define MAINWINDOW_H

#include <QMainWindow>

#include "FileListModel.h"

QT_BEGIN_NAMESPACE
namespace Ui { class MainWindow; }
QT_END_NAMESPACE

class QListView;

class MainWindow : public QMainWindow
{
    Q_OBJECT

public:
    MainWindow(QWidget *parent = nullptr);
    ~MainWindow();

private slots:
    void on_usernameBox_textChanged(const QString &arg1);
    void on_machineBox_textChanged(const QString &arg1);
    void on_directoryBox_textChanged(const QString &arg1);
    void on_pushButton_pressed();

    void on_selectButton_clicked();

    void on_listView_clicked(const QModelIndex &index);

private:
    FileListModel m_model;
    QString m_userName, m_machine, m_directory;
    const QModelIndex *m_selected_index;
    Ui::MainWindow *ui;
};
#endif // MAINWINDOW_H
