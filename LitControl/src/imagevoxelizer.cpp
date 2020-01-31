#include "include/imagevoxelizer.h"
#include "include/voxelizer.h"

void ImageVoxelizer::voxelize(std::string filename, bool center, bool resize){
    ObjReader *objr = new ObjReader(filename);
    if(center)
        objr->center(objr->getCenterVector());
    if(resize)
        objr->resize(objr->getResizeFactor());
    objr->getFacesFromFile();
    Voxelizer::voxelize(objr->getFaces(), objr->getColors(), filename + ".ppm");
}

