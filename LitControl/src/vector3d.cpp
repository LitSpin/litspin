#include <iostream>
#include <cmath>
#include <sstream>
#include "include/vector3d.h"

#define PI atan(1)*4

Vector3D::Vector3D(double x, double y, double z):
    m_x(x),
    m_y(y),
    m_z(z)
{};

Vector3D::Vector3D() {}

Vector3D::Vector3D(const Vector3D &v) : Vector3D(v.m_x, v.m_y, v.m_z)
{

}

Vector3D * Vector3D::createFromCyl(double r, double theta, double z) {
  return new Vector3D(r*cos(theta*(PI/180)), r*sin(theta*(PI/180)), z);
}

double Vector3D::getX() const {
  return m_x;
}

double Vector3D::getY() const {
  return m_y;
}

double Vector3D::getZ() const {
  return m_z;
}

void Vector3D::display() {
  printf("%lf %lf %lf\n", m_x, m_y, m_z);
}

Vector3D operator + (const Vector3D &v1, const Vector3D &v2) {
  return Vector3D(v1.m_x + v2.m_x, v1.m_y + v2.m_y, v1.m_z + v2.m_z);
}

Vector3D operator - (const Vector3D &v1, const Vector3D &v2) {
  return Vector3D(v1.m_x - v2.m_x, v1.m_y - v2.m_y, v1.m_z - v2.m_z);
}

Vector3D operator * (const Vector3D &v1, double d) {
  return Vector3D(v1.m_x*d, v1.m_y*d, v1.m_z*d);
}

bool operator == (const Vector3D &v1, const Vector3D &v2) {
  return v1.m_x==v2.m_x && v1.m_y==v2.m_y && v1.m_z==v2.m_z;
}

double Vector3D::dotProduct(const Vector3D &v) const {
  return m_x*v.getX() + m_y*v.getY() + m_z*v.getZ();
}

Vector3D Vector3D::crossProduct(const Vector3D &v) const {
  double cX = m_y*v.getZ() - m_z*v.getY();
  double cY = m_z*v.getX() - m_x*v.getZ();
  double cZ = m_x*v.getY() - m_y*v.getX();
  return Vector3D(cX, cY, cZ);
}

bool Vector3D::compareZ(const Vector3D &v1, const Vector3D &v2) {
  return v1.getZ() < v2.getZ();
}

bool Vector3D::compareX(const Vector3D &v1, const Vector3D &v2) {
  return v1.getX() < v2.getX();
}

double Vector3D::distanceTo(const Vector3D &v) const {
  return sqrt(pow(m_x-v.getX(),2)+pow(m_y-v.getY(),2)+pow(m_z-v.getZ(),2));
}

size_t Vector3D::hash::operator()(Vector3D &v)
{
    std::stringstream ss;
    ss << v.m_x << ',' << v.m_y << ',' << v.m_z;
    std::hash<std::string> str_hash;
    return str_hash(ss.str());
}
