#ifndef VIDEOVOXELIZER_H
#define VIDEOVOXELIZER_H
#include <string>

class VideoVoxelizer{
public:
     static int voxelize(std::string filename, int center, int resize);
};

#endif // VIDEOVOXELIZER_H
