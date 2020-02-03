#include <iostream>
#include <filesystem>
#include <cfloat>
#include <cmath>

#include <QThreadPool>


#include "include/voxelizer.h"
#include "include/videovoxelizer.h"
#include "include/objreader.h"
namespace fs = std::filesystem;

int VideoVoxelizer::voxelize(std::string folder, int center, int resize){
    int out = 0;
    std::vector<ObjReader *> readers;
    //find obj files in given folder
    for(const auto& file : std::filesystem::directory_iterator(folder)){
        std::string path = file.path();
        //see if found file are obj files.
        if(path.substr(path.size()-4, 4) == ".obj")
            readers.push_back(new ObjReader(path.substr(0, path.size()-4)));
    }
    if(center == 2){
        double min_X = DBL_MAX, max_X = DBL_MIN;
        double min_Y = DBL_MAX, max_Y = DBL_MIN;
        double min_Z = DBL_MAX, max_Z = DBL_MIN;
        for(ObjReader* obj : readers){
            std::pair<Vector3D, Vector3D> extremes = obj->getExtremes();
            Vector3D v1 = std::get<0>(extremes), v2 = std::get<1>(extremes);
            min_X = fmin(min_X, v1.getX());
            min_Y = fmin(min_Y, v1.getY());
            min_Z = fmin(min_Z, v1.getZ());
            max_X = fmax(max_X, v2.getX());
            max_Y = fmax(max_Y, v2.getY());
            max_Z = fmax(max_Z, v2.getZ());
        }
        Vector3D delta = Vector3D(max_X - min_X, max_Y - min_Y, max_Z - min_Z)*0.5 + Vector3D(min_X, min_Y, min_Z);
        for(ObjReader* obj : readers)
            obj->center(delta);
    }
    if(resize == 2){
        double fact = DBL_MIN;
        for(ObjReader* obj : readers)
            fact = fmax(fact, obj->getResizeFactor());
        for(ObjReader* obj : readers)
            obj->resize(fact);
    }
    QThreadPool voxel_pool = QThreadPool();
    voxel_pool.setMaxThreadCount(4);
    voxel_pool.setExpiryTimeout(100000);
    for(ObjReader* obj : readers){
        obj->getFacesFromFile();
        voxel_pool.start(new Voxelizer(obj->getFaces(), obj->getColors(), obj->getPath() + ".ppm"));
    }
    voxel_pool.waitForDone();
    return out;
}
