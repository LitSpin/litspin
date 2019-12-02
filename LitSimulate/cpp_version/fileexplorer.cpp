#include "fileexplorer.h"
#include <QFileDialog>
#include <iostream>


FileExplorer::FileExplorer(QWidget * parent) : QPushButton(parent) {
    connect(this, SIGNAL(clicked()), this, SLOT(choose_file()));
}

QString FileExplorer::get_file_name(){
    return filename;
}

void FileExplorer::choose_file(){
    filename = QFileDialog::getOpenFileName(this, "Open Image", "/home", "Image Files (*.png *.jpg *.bmp)");
    if (filename.size()){
        emit file_chosen(filename);
    }
}
