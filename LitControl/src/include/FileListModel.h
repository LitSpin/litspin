#ifndef FILELISTMODEL_H
#define FILELISTMODEL_H

#include <QProcess>
#include <QStringListModel>

class FileListModel : public QStringListModel
{
    Q_OBJECT
public:
    FileListModel();
    void launchUpdate(const QString &userName, const QString &machine, const QString &directory);

    void select(const QString &userName, const QString &machine, const QString &directory, const QModelIndex &index);

private:
    QProcess m_lsProcess;
    QProcess m_remoteProcess;

private slots:
    void update(int, QProcess::ExitStatus);

signals:
    void updated(const QModelIndex &topLeft, const QModelIndex &bottomRight);
};

#endif // FILELISTMODEL_H
