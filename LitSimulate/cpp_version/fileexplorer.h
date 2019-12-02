#ifndef FILEEXPLORER_H
#define FILEEXPLORER_H

#include <QPushButton>
#include <QString>


class FileExplorer : public QPushButton
{
    Q_OBJECT

private:
    QString filename;

public:
    FileExplorer(QWidget * parent = nullptr);
    ~FileExplorer(){}
    QString get_file_name();

private slots:
    void choose_file();

signals:
    void file_chosen(QString path);

};

#endif // FILEEXPLORER_H
