#include <iostream>
#include <sstream>
#include <fstream>
#include <iostream>
#include <cmath>
#include <algorithm>

#include "include/objreader.h"
#include "include/face.h"
#include "include/voxelizer.h"

#define NB_CIRCLES 20
#define ANG_SUBDIVISIONS 128
#define NB_LEDS_VERTICAL 32

#define PI 3.14159

void Voxelizer::voxelize(std::vector<Face> faces, std::map<std::string, std::vector<double>> obj_colors, std::string outputFile)
{

    double voxels[NB_CIRCLES * NB_LEDS_VERTICAL][ANG_SUBDIVISIONS][3] = {};
    for (int i = 0; i < NB_CIRCLES; i++)
    {
        for (int k = 0; k < ANG_SUBDIVISIONS; k++)
        {
            // creating vertical ray
            Vector3D * orig = Vector3D::createFromCyl(double((2*i+1)*(double(RADIUS)/(2*double(NB_CIRCLES)))), double(k*(360/double(ANG_SUBDIVISIONS))), double(2*HEIGHT));
            Vector3D * dir = new Vector3D(0,0,-1);
            std::vector<Vector3D> intersectPts;
            // to keep track of which face will be intersected
            std::vector<unsigned long> ind_face;
            // check intersection with every face of the object
            Vector3D res;
            for (long unsigned int l=0; l<faces.size(); l++)
            {
                Face cur_face = faces[l];
                if (RayIntersectsTriangle(*orig, *dir, cur_face.getAngles()[0], cur_face.getAngles()[1], cur_face.getAngles()[2], res))
                {
                    // checks for duplicate (in case of crossing two faces at once)
                    int ok=1;
                    for (long unsigned int tmp = 0; tmp!=intersectPts.size(); tmp++)
                    {
                        if (res==intersectPts[tmp])
                            ok = 0;
                    }
                    if (ok)
                    {
                        intersectPts.push_back(res);
                        ind_face.push_back(l);
                    }
                }
            }
            // sort intersect points by increasing z
            if (intersectPts.size()!=0)
            {
                sort(intersectPts.begin(), intersectPts.end(), Vector3D::compareZ);
                // x and y are the same for all intersectPts elements they can be computed now
                double x = intersectPts[0].getX();
                double y = intersectPts[0].getY();
                // conversion to polar coordinates
                double r = sqrt(pow(x,2) + pow(y,2));
                double theta = atan(y/x);
                if (x<0)
                {
                    theta = (theta+PI);
                }
                if (x>0 && y<0)
                {
                    theta = theta + 2*PI;
                }
                theta = int(theta * (180/PI));
                if (intersectPts.size()%2)
                {
                    intersectPts.pop_back();
                }
                // convert back to polar, and then to our grid coordinates
                for (long unsigned int j = 0; j!= intersectPts.size(); j = j+2)
                {
                    int ang = int((theta*128)/360);
                    if (((theta*128)/360-int((theta*128)/360) > 0.5))
                    {
                        ang ++;
                    }
                    int ray = int((r*double(NB_CIRCLES))/double(RADIUS));
                    int z_start = (-int((intersectPts[j].getZ()*NB_LEDS_VERTICAL)/double(HEIGHT)))+16;
                    int z_end = (-int((intersectPts[j+1].getZ()*NB_LEDS_VERTICAL)/double(HEIGHT)))+16;
                    //z_start is higher than z_end because higher z have lower idexes in the output file
                    for (int z = z_end; z!=z_start+1; z++)
                    {
                        unsigned long ind;
                        if (abs(z-z_start)<abs(z-z_end))
                        {
                            ind = static_cast<unsigned long>(j);
                        }
                        else
                        {
                            ind = static_cast<unsigned long>(j+1);
                        }
                        // get the color of the face crossed
                        std::string mtl = faces[ind_face[ind]].getMtl();
                        std::vector<double> rgb = obj_colors[mtl];
                        voxels[(NB_CIRCLES-ray-1)*NB_LEDS_VERTICAL+z][ang][0] = rgb[0];
                        voxels[(NB_CIRCLES-ray-1)*NB_LEDS_VERTICAL+z][ang][1] = rgb[1];
                        voxels[(NB_CIRCLES-ray-1)*NB_LEDS_VERTICAL+z][ang][2] = rgb[2];
                    }
                }
            }
        }
    }
    // same thing with horizontal rays
    for (int j = -16; j<16; j++)
    {
        for (int i = 0; i < ANG_SUBDIVISIONS/2; i++)
        {
            Vector3D * orig = Vector3D::createFromCyl(RADIUS, double(i*(360/double(ANG_SUBDIVISIONS))), double((j*(double(HEIGHT/NB_LEDS_VERTICAL)))));
            Vector3D * dir = Vector3D::createFromCyl(RADIUS*2, double(i*(360/double(ANG_SUBDIVISIONS))+180), 0);
            std::vector<Vector3D> intersectPts;
            std::vector<unsigned long> ind_face;
            Vector3D res;
            for (long unsigned int l=0; l<faces.size(); l++) {
                Face cur_face = faces[l];
                if (RayIntersectsTriangle(*orig, *dir, cur_face.getAngles()[0], cur_face.getAngles()[1], cur_face.getAngles()[2], res)) {
                    // checks for duplicate (in case of crossing two faces at once)
                    int ok=1;
                    for (long unsigned int tmp = 0; tmp!=intersectPts.size(); tmp++)
                    {
                        if (res==intersectPts[tmp])
                            ok = 0;
                    }
                    if (ok)
                    {
                        intersectPts.push_back(res);
                        ind_face.push_back(l);
                    }
                }
            }
            // sort by increasing x
            if (intersectPts.size()!=0)
            {
                sort(intersectPts.begin(), intersectPts.end(), Vector3D::compareX);
                // convert back to polar, and then to our grid coordinates
                for (long unsigned int k = 0; k!=intersectPts.size(); k++) {
                    double x = intersectPts[k].getX();
                    double y = intersectPts[k].getY();
                    // convert back to cylindrical
                    double r = sqrt(pow(x,2)+pow(y,2));
                    // theta between -PI/2 and PI/2
                    double theta = atan(y/x);
                    // theta between 0 and 2*PI
                    if (x<0)
                    {
                        theta = (theta+PI);
                    }
                    if (x>0 && y<0)
                    {
                        theta = theta + 2*PI;
                    }
                    // in degrees
                    theta = int(theta * (180/PI));
                    int ray = int(((r*double(NB_CIRCLES))/double(RADIUS)));
                    int ang = int((theta*128)/360);
                    int z = (-int(((intersectPts[k].getZ()*NB_LEDS_VERTICAL)/double(HEIGHT))))+16;
                    // get the color of the face crossed
                    std::string mtl = faces[ind_face[k]].getMtl();
                    std::vector<double> rgb = obj_colors[mtl];
                    voxels[(NB_CIRCLES-ray-1)*NB_LEDS_VERTICAL+z][ang][0] = rgb[0];
                    voxels[(NB_CIRCLES-ray-1)*NB_LEDS_VERTICAL+z][ang][1] = rgb[1];
                    voxels[(NB_CIRCLES-ray-1)*NB_LEDS_VERTICAL+z][ang][2] = rgb[2];
                }
            }
        }
    }
    std::cout << "voxelization over" <<std::endl;

    // write in ppm file
    std::cout << "writing to " + outputFile <<std::endl;
    std::ofstream myfile;
    myfile.open (outputFile);
    if(!myfile.is_open())
    {
        std::cerr << "error opening file " + outputFile<< std::endl;
    }
    myfile << "P3\n";
    myfile << ANG_SUBDIVISIONS << " " << NB_CIRCLES*NB_LEDS_VERTICAL << "\n";
    myfile << "255\n";
    for (int i = 0; i < NB_CIRCLES*NB_LEDS_VERTICAL; i++)
    {
        for (int j = 0; j < ANG_SUBDIVISIONS; j++)
        {
            myfile << int(voxels[i][j][0] * 255.) << " " << int(voxels[i][j][1] * 255.) << " " << int(voxels[i][j][2] * 255.) << "\n";
        }
    }
    myfile.flush();
    myfile.close();
}

bool Voxelizer::RayIntersectsTriangle(const Vector3D &rayOrigin,
                                      const Vector3D &rayVector,
                                      const Vector3D &p0,
                                      const Vector3D &p1,
                                      const Vector3D &p2,
                                      Vector3D& outIntersectionPoint)
{
    Vector3D edge1, edge2, h, s, q;
    double a,f,u,v;
    edge1 = p1 - p0;
    edge2 = p2 - p0;
    h = rayVector.crossProduct(edge2);
    a = edge1.dotProduct(h);
    if (a > -EPSILON && a < EPSILON)
        return false;    // This ray is parallel to this triangle.
    f = 1.0/a;
    s = rayOrigin - p0;
    u = f * s.dotProduct(h);
    if (u < 0.0 || u > 1.0)
        return false;
    q = s.crossProduct(edge1);
    v = f * rayVector.dotProduct(q);
    if (v < 0.0 || u + v > 1.0)
        return false;
    // At this stage we can compute t to find out where the intersection point is on the line.
    double t = f * edge2.dotProduct(q);
    if (t > EPSILON && t < 1 - EPSILON) // ray intersection
    {
        outIntersectionPoint = rayOrigin + rayVector * t;
        return true;
    }
    else // This means that there is a line intersection but not a ray intersection.
        return false;
}
