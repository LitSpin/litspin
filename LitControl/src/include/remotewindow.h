#ifndef REMOTEWINDOW_H
#define REMOTEWINDOW_H

#include <QDialog>
#include "FileListModel.h"

QT_BEGIN_NAMESPACE
namespace Ui { class RemoteWindow; }
QT_END_NAMESPACE

class QListView;

class RemoteWindow : public QDialog {

    Q_OBJECT

public:
    explicit RemoteWindow(QWidget *parent = nullptr);
    ~RemoteWindow();

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
    Ui::RemoteWindow *ui;

};

#endif // REMOTEWINDOW_H
