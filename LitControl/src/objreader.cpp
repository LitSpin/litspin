#include <fstream>
#include <iostream>
#include <sstream>
#include <locale>
#include <cfloat>
#include <cmath>

#include "include/objreader.h"

ObjReader::ObjReader(std::string fname): filename(fname) {

    std::setlocale(LC_ALL, "C");

    // parsing of obj file
    std::ifstream infile (filename+".obj");
    if (infile.is_open()) {
        std::cout << "reading " + filename +".obj" << std::endl;
        // line currently processed
        std::string line;
        // list of every vertex (so that they can be accessed easily)
        std::vector<std::string> s_vertex;

        while(std::getline(infile, line) && line[0]!='v');
        do{
            s_vertex.push_back(line);
        }while (std::getline(infile, line) && line[0]=='v');
        std::size_t found = line.find_last_of(" ");
        std::size_t next = line.size();
        for(std::string v_line : s_vertex){
            std::vector<double> v_coor;
            next = v_line.size();
            found = v_line.find_last_of(" ");
            while (found!=std::string::npos) {
                v_coor.push_back(stod(v_line.substr(found+1, next-found-1)));
                next = found;
                found = v_line.find_last_of(" ", next-1);
            }
            vectors.push_back(Vector3D(v_coor[2],v_coor[1],v_coor[0]));
        }
        infile.close();
    }
    else {
        std::cerr << filename + ".obj " + "file cannot be opened" <<  std::endl;
    }
    getFacesFromFile();
}


void ObjReader::getFacesFromFile(){
    std::setlocale(LC_ALL, "C");

    // parsing of obj file
    std::ifstream infile (filename+".obj");
    std::cout << "reading " + filename +".obj" << std::endl;
    // line currently processed
    std::string line;
    // to link the material to the face number
    std::string mtl_name;
    do{
        std::size_t found = line.find_last_of(" ");
        std::size_t next = line.size();
        if (line.substr(0,6)=="usemtl") {
            std::size_t found = line.find_first_of(" ");
            mtl_name = line.substr(found+1,std::string::npos);
        }
        else if(line[0]=='f'){
            found = line.find_last_of(" ");
            // list of the 3 Vertex3D objects that define the face
            std::vector<Vector3D> coord;
            // list of file lines where to find the vertex coordinates
            std::vector<int> indexes;
            next = line.size();
            while (found!=std::string::npos) {
                indexes.push_back(stoi(line.substr(found+1, next-found-1)));
                next = found;
                found = line.find_last_of(" ", next-1);
            }
            for (int index : indexes) {
                //get the right vectors to put in a face
                Vector3D vector = vectors[static_cast<unsigned long>(index)-1];
                coord.push_back(vector);
            }
            faces.push_back(Face(coord, mtl_name));
        }
    }while(std::getline(infile, line));

    infile.close();
    //parsing of mtl file
    infile.open(filename+".mtl");
    if (infile.is_open()) {
        std::cout << "reading " + filename +".mtl"  << std::endl;
        std::string line;
        std::string mtl_name;
        while (std::getline(infile, line)) {
            if (line.substr(0,6) == "newmtl") {
                std::size_t found = line.find_first_of(" ");
                mtl_name = line.substr(found+1,std::string::npos);
            }
            else if (line.substr(0,2) == "Kd") {
                //get the RGB components
                std::size_t found = line.find_last_of(" ");
                // list of the rgb values
                std::vector<double> rgb;
                std::size_t next = line.size();
                while (found!=std::string::npos) {
                    rgb.insert(rgb.begin(), stod(line.substr(found+1, next-found-1)));
                    next = found;
                    found = line.find_last_of(" ", next-1);
                }
                colors[mtl_name] = rgb;
            }
        }
    }
    else {
        std::cerr << "mtl file cannot be opened" <<  std::endl;
    }

    infile.close();
}

std::vector<Face> ObjReader::getFaces() {
    return faces;
}

std::map<std::string, std::vector<double>> ObjReader::getColors() {
    return colors;
}

Vector3D ObjReader::getCenterVector(){
    //find the center of the object t display
    double min_X = DBL_MAX, max_X = DBL_MIN;
    double min_Y = DBL_MAX, max_Y = DBL_MIN;
    double min_Z = DBL_MAX, max_Z = DBL_MIN;
    for(Vector3D vector : vectors){
        min_X = fmin(min_X, vector.getX());
        min_Y = fmin(min_Y, vector.getY());
        min_Z = fmin(min_Z, vector.getZ());
        max_X = fmax(max_X, vector.getX());
        max_Y = fmax(max_Y, vector.getY());
        max_Z = fmax(max_Z, vector.getZ());
    }
    //compute the vector needed to center the object and center the object
    Vector3D delta = Vector3D(max_X - min_X, max_Y - min_Y, max_Z - min_Z)*0.5 + Vector3D(min_X, min_Y, min_Z);
    return delta;
}

void ObjReader::center(Vector3D center_vector){
    for(Vector3D& vector : vectors){
        vector = vector - center_vector;
    }
}

double ObjReader::getResizeFactor(){
    //find the factor for adjusting the proportions.
    double radius = DBL_MIN;
    double min_Z = DBL_MAX, max_Z = DBL_MIN;
    double height = max_Z - min_Z;
    for(Vector3D vector : vectors){
        min_Z = fmin(min_Z, vector.getZ());
        max_Z = fmax(max_Z, vector.getZ());
    }
    for(Vector3D& vector : vectors){
       radius = fmax(pow(vector.getX(), 2) + pow(vector.getY(), 2), radius);
    }
    double fact = 1/fmax(height/HEIGHT, radius/RADIUS);
    return fact;
}

void ObjReader::resize(double resize_factor){
    for(Vector3D &vector : vectors)
        vector = vector*resize_factor;
}
