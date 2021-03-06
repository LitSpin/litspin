#include <iostream>
#include <sstream>
#include <fstream>
#include <iostream>
#include <cmath>
#include <algorithm>
#include "include/vector3d.h"
#include "include/objreader.h"
#include "include/face.h"

#define NB_CIRCLES 20
#define ANG_SUBDIVISIONS 128
#define HEIGHT 0.10
#define RADIUS 0.12

#define PI 3.14159

bool RayIntersectsTriangle(Vector3D rayOrigin,
                           Vector3D rayVector,
                           Vector3D p0,
                           Vector3D p1,
                           Vector3D p2,
                           Vector3D& outIntersectionPoint);

int main (int argc, char *argv[]) {
  std::string filename = argv[1];
  std::cout << filename << std::endl;
  ObjReader * objr = new ObjReader(filename);

  // 32 nb of leds to drive
  double voxels[NB_CIRCLES*32][ANG_SUBDIVISIONS][3] = {};

  std::vector<Face> faces = objr->getFaces();
  std::cout << "start of voxelization..." << std::endl;
  for (int i=0; i<NB_CIRCLES; i++) {
    for (int k=0; k<ANG_SUBDIVISIONS; k++) {
      //std::cout << "circle: " << i  << " ang: " << k << std::endl;
      // creating vertical ray
      Vector3D * orig = Vector3D::createFromCyl((double)((2*i+1)*((double)RADIUS/(2*(double)NB_CIRCLES))), (double)k*(360/(double)ANG_SUBDIVISIONS), (double)2*HEIGHT);
      Vector3D * dir = new Vector3D(0,0,-1);
      std::vector<Vector3D> intersectPts;
      // to keep track of which face will be intersected
      std::vector<int> ind_face;
      // check intersection with every face of the object
      Vector3D res;
      for (long unsigned int l=0; l<faces.size(); l++) {
        Face cur_face = faces[l];
        if (RayIntersectsTriangle(*orig, *dir, cur_face.getAngles()[0], cur_face.getAngles()[1], cur_face.getAngles()[2], res)) {
          // checks fro duplicate (in case of crossing two faces at once)
          int ok=1;
          for (long unsigned int tmp = 0; tmp!=intersectPts.size(); tmp++) {
            if (res==intersectPts[tmp])
              ok = 0;
          }
          if (ok) {
            intersectPts.push_back(res);
            ind_face.push_back(l);
          }
        }
      }
      // sort intersect points by increasing z
      if (intersectPts.size()!=0) {
        sort(intersectPts.begin(), intersectPts.end(), Vector3D::compareZ);
        // x and y are the same for all intersectPts elements they can be computed now
        double x = intersectPts[0].getX();
        double y = intersectPts[0].getY();
        // conversion to polar coordinates
        double r = sqrt(pow(x,2)+pow(y,2));
        double theta = atan(y/x);
        if (x<0) {
          theta = (theta+PI);
        }
        if (x>0 && y<0) {
          theta = theta + 2*PI;
        }
        theta = (int)(theta * (180/PI));
        if (intersectPts.size()%2) {
          intersectPts.pop_back();
        }
        // convert back to polar, and then to our grid coordinates
        std::map<std::string, std::vector<double>> obj_color = objr->getColors();
        for (long unsigned int j = 0; j!= intersectPts.size(); j = j+2) {
          //std::cout << "polar: r = " << r << " th = " << theta << std::endl;
          int ang = (int)(theta*128)/360;
          if ((theta*128)/360-(int)(theta*128)/360 > 0.5) {
            ang ++;
          }
          std::cout << "theta non int: " << (theta*128)/360 << std::endl;
          if (ang==79 || ang ==31)
            std::cout << "STOOOOOOP" << std::endl;
          int ray = (int)((r*(double)NB_CIRCLES)/(double)RADIUS);
          //std::cout << "rayon: " << ray  << " ang: " << ang << std::endl;
          int z_start = (-(int)((intersectPts[j].getZ()*32)/(double)HEIGHT))+16;
          int z_end = (-(int)((intersectPts[j+1].getZ()*32)/(double)HEIGHT))+16;
          //std::cout << "z_start: " << z_start << " z_end: " << z_end << std::endl;
          //z_start is higher than z_end because higher z have lower indices in the output file
          for (int z = z_end; z!=z_start+1; z++) {
            int ind;
            if (abs(z-z_start)<abs(z-z_end)) {
              ind = j;
            }
            else {
              ind = j+1;
            }
            // get the color of the face crossed
            int bouh = ind_face[ind];
            Face test = faces[bouh];
            std::string mtl = test.getMtl();
            std::vector<double> rgb = obj_color[mtl];
            std::cout << "ang: " << ang << std::endl;
            //std::cout << "writing to line: " << (NB_CIRCLES-ray-1) << " for ray: " << ray << std::endl;
            voxels[(NB_CIRCLES-ray-1)*32+z][ang][0] = rgb[0];
            voxels[(NB_CIRCLES-ray-1)*32+z][ang][1] = rgb[1];
            voxels[(NB_CIRCLES-ray-1)*32+z][ang][2] = rgb[2];
          }
        }
      }
    }
  }
  // same thing with horizontal rays
  std::cout << "round 2" << std::endl;
  for (int j = -16; j<16; j++) {
    for (int i = 0; i<ANG_SUBDIVISIONS/2; i++) {
      //std::cout << "ang: " << (double)i*(360/(double)ANG_SUBDIVISIONS) << " height: " << j << std::endl;
      Vector3D * orig = Vector3D::createFromCyl(RADIUS, (double)i*(360/(double)ANG_SUBDIVISIONS), (double)(j*((double)HEIGHT/32)));
      Vector3D * dir = Vector3D::createFromCyl(RADIUS*2, (double)i*(360/(double)ANG_SUBDIVISIONS)+180, 0);
      std::vector<Vector3D> intersectPts;
      std::vector<int> ind_face;
      Vector3D res;
      for (long unsigned int l=0; l<faces.size(); l++) {
        Face cur_face = faces[l];
        if (RayIntersectsTriangle(*orig, *dir, cur_face.getAngles()[0], cur_face.getAngles()[1], cur_face.getAngles()[2], res)) {
          // checks for duplicate (in case of crossing two faces at once)
          int ok=1;
          //res.display();
          for (long unsigned int tmp = 0; tmp!=intersectPts.size(); tmp++) {
            if (res==intersectPts[tmp])
              ok = 0;
          }
          if (ok) {
            intersectPts.push_back(res);
            ind_face.push_back(l);
          }
        }
      }
      // sort by increasing x
      if (intersectPts.size()!=0) {
        sort(intersectPts.begin(), intersectPts.end(), Vector3D::compareX);
        // convert back to polar, and then to our grid coordinates
        std::map<std::string, std::vector<double>> obj_color = objr->getColors();
        for (long unsigned int k = 0; k!=intersectPts.size(); k++) {
          double x = intersectPts[k].getX();
          double y = intersectPts[k].getY();
          // convert back to cylindric
          double r = sqrt(pow(x,2)+pow(y,2));
          // theta between -PI/2 and PI/2
          double theta = atan(y/x);
          // theta between 0 and 2*PI
          if (x<0) {
            theta = (theta+PI);
          }
          if (x>0 && y<0) {
            theta = theta + 2*PI;
          }
          // in degrees
          theta = (int)(theta * (180/PI));
          //std::cout << "theta in degrees: " << theta << std::endl;
          int ray = (int)((r*(double)NB_CIRCLES)/(double)RADIUS);
          int ang = (int)(theta*128)/360;
          //std::cout << "int ang: " << ang << std::endl;
          int z = (-(int)((intersectPts[k].getZ()*32)/(double)HEIGHT))+16;
          // get the color of the face crossed
          int bouh = ind_face[k];
          Face test = faces[bouh];
          std::string mtl = test.getMtl();
          std::vector<double> rgb = obj_color[mtl];
          //std::cout << "writing to line: " << (NB_CIRCLES-ray-1) << " for ray: " << ray << std::endl;
          voxels[(NB_CIRCLES-ray-1)*32+z][ang][0] = rgb[0];
          voxels[(NB_CIRCLES-ray-1)*32+z][ang][1] = rgb[1];
          voxels[(NB_CIRCLES-ray-1)*32+z][ang][2] = rgb[2];
        }
      }

    }
  }
  std::cout << "over" << std::endl;

  // write in ppm file
  std::ofstream myfile;
  myfile.open ("data/" + filename + ".ppm");
  myfile << "P3\n";
  myfile << ANG_SUBDIVISIONS << " " << NB_CIRCLES*32 << "\n";
  myfile << "255\n";
  for (int i = 0; i!=NB_CIRCLES*32; i++) {
    for (int j = 0; j!= ANG_SUBDIVISIONS; j++) {
      myfile << int(voxels[i][j][0]*255) << " " << int(voxels[i][j][1]*255) << " " << int(voxels[i][j][2]*255) << "\n";
    }
  }
  myfile.close();
}

// taken from the wikipedia page of the Möller–Trumbore algorithm
bool RayIntersectsTriangle(Vector3D rayOrigin,
                           Vector3D rayVector,
                           Vector3D p0,
                           Vector3D p1,
                           Vector3D p2,
                           Vector3D& outIntersectionPoint)
{
    const float EPSILON = 0.0000001;
    Vector3D edge1, edge2, h, s, q;
    float a,f,u,v;
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
    float t = f * edge2.dotProduct(q);
    if (t > EPSILON && t < 1 - EPSILON) // ray intersection
    {
        outIntersectionPoint = rayOrigin + rayVector * t;
        return true;
    }
    else // This means that there is a line intersection but not a ray intersection.
        return false;
}
/*
void text_to_vox(std::string text) {
  std::ifstream myfile("data/Sinclair_S.ppm");
  if (myfile.is_open()) {

  }
  else {
    std::cerr << "error opening font file" << std::endl;
  }
}
*/

