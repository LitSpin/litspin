#ifndef VECTOR3D_H
#define VECTOR3D_H

#include <string>
#define EPSILON 0.0000001
#define HEIGHT 0.10
#define RADIUS 0.12


// cartesian representation of a 3D vector
class Vector3D
{

private:
    double m_x, m_y, m_z;

public:
    Vector3D(double x, double y, double z);
    Vector3D();
    Vector3D(const Vector3D &v);

    struct hash : public std::hash<Vector3D>
    {
        size_t operator()(Vector3D &v);
    };

    static Vector3D * createFromCyl(double r, double theta, double z);
    void display() const;
    double getX() const;
    double getY() const;
    double getZ() const;
    friend Vector3D operator + (const Vector3D &v1, const Vector3D &v2);
    friend Vector3D operator - (const Vector3D &v1, const Vector3D &v2);
    friend Vector3D operator * (const Vector3D &v, double d);
    void operator = (const Vector3D &v);
    friend bool operator == (const Vector3D &v1, const Vector3D &v2);

    double dotProduct(const Vector3D &v) const;
    Vector3D crossProduct(const Vector3D &v) const;
    static bool compareZ(const Vector3D &v1, const Vector3D &v2);
    static bool compareX(const Vector3D &v1, const Vector3D &v2);
    double distanceTo(const Vector3D &v) const;

};

#endif //VECTOR3D_H
