#include "include/FileListModel.h"
#include <iostream>

#define REMOTE_PROGRAM "touch"

FileListModel::FileListModel()
{
    connect(&m_lsProcess, SIGNAL(finished(int, QProcess::ExitStatus)), this, SLOT(update(int, QProcess::ExitStatus)));
}

void FileListModel::launchUpdate(const QString &userName, const QString &machine, const QString &directory)
{
    QStringList args;
    args.append(userName + "@" + machine);
    args.append("ls " + directory);
    m_lsProcess.start("ssh", args);
}

void FileListModel::select(const QString &userName, const QString &machine, const QString &directory, const QModelIndex &index)
{
    QString fileName = data(index).toString();
    if(directory != "")
        fileName = directory + "/" + fileName;
    QStringList args;
    args.append(userName + "@" + machine);
    args.append(REMOTE_PROGRAM);
    args.append(fileName + "_touched");
    m_remoteProcess.start("ssh", args);
}

void FileListModel::update(int, QProcess::ExitStatus)
{
    auto _output = m_lsProcess.readAllStandardOutput();
    QString output = QString(_output.toStdString().c_str());
    QStringList list = output.split('\n');
    setStringList(list);
}
