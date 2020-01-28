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
    emit file_choice();
    filename = QFileDialog::getOpenFileName(this, "Open Image", "/home", "Image and Video Files (*.png *.ppm *.obj *.gif *.mp4)");
    if (filename.size()){
        emit file_chosen(filename);
    }
}
