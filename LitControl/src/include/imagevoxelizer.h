#ifndef IMAGEVOXELIZER_H
#define IMAGEVOXELIZER_H
#include "objreader.h"
#include "voxelizer.h"

class ImageVoxelizer{
public:
    static void voxelize(std::string filename, int center, int resize);

};

#endif // IMAGEVOXELIZER_H
