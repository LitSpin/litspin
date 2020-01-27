#ifndef VECTOR3D_H
#define VECTOR3D_H

#include <tuple>

// cartesian representation of a 3D vector
class Vector3D
{

private:
    double m_x, m_y, m_z;

public:
    Vector3D(double x, double y, double z);
    Vector3D();

    static std::string hashKey(Vector3D& v);

    static Vector3D * createFromCyl(double r, double theta, double z);
    void display();
    double getX() const;
    double getY() const;
    double getZ() const;
    friend Vector3D operator + (Vector3D v1, Vector3D v2);
    friend Vector3D operator - (Vector3D v1, Vector3D v2);
    friend Vector3D operator * (Vector3D v, double d);
    friend bool operator == (Vector3D v1, Vector3D v2);
    double dotProduct(Vector3D v);
    Vector3D crossProduct(Vector3D v);
    static bool compareZ(Vector3D v1, Vector3D v2);
    static bool compareX(Vector3D v1, Vector3D v2);
    double distanceTo(Vector3D v);

};

#endif //VECTOR3D_H
