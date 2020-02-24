#ifndef MAINWINDOW_H
#define MAINWINDOW_H

#include <QMainWindow>
#include <QString>

namespace Ui {
class MainWindow;
}

class MainWindow : public QMainWindow
{
    Q_OBJECT

public:
    explicit MainWindow(QWidget *parent = nullptr);
    ~MainWindow();

private:
    Ui::MainWindow *ui;


private slots:
    void file_explore();
    void receive_file(QString file);
    void h_changed(int h);
    void change_mode(int mode);
    void change_fps(int fps);

    void center_mode(int mode);
    void resize_mode(int mode);

    void on_pushButton_3_clicked();

signals:
    void file_transmit(QString path);
    void file_choice();
    void new_h(int h);
    void mode_changed(int mode);
    void fps_changed(int fps);
    void center_mode_set(int mode);
    void resize_mode_set(int mode);

};

#endif // MAINWINDOW_H
