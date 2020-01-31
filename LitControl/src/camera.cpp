#include <GL/glu.h>
#include <iostream>
#include <math.h>

#include "include/camera.h"

Camera::Camera(glm::vec3 center) : m_center(center)
{
    setPositionSpherical(30, 0, 0);
}

void Camera::setPosition(float x, float y, float z)
{
    m_position.x = x;
    m_position.y = y;
    m_position.z = z;
}

void Camera::setPositionSpherical(float r, float theta, float phi)
{
    if(r < 0) r = 0;
    m_r = r;
    m_theta = theta;
    if(phi < - float(M_PI)/2) phi = - float(M_PI)/2;
    if(phi >   float(M_PI)/2) phi =   float(M_PI)/2;
    m_phi = phi;

    setPosition(r * cos(theta) * cos(phi) + m_center.x,
                r * sin(theta) * cos(phi) + m_center.y,
                r * sin(phi)              + m_center.z);
}

void Camera::moveRadius(float delta)
{
    setPositionSpherical(m_r + delta, m_theta, m_phi);
}

void Camera::moveTheta(float delta)
{
    setPositionSpherical(m_r, m_theta + delta, m_phi);
}

void Camera::movePhi(float delta)
{
    setPositionSpherical(m_r, m_theta, m_phi + delta);
}

void Camera::update(float width, float height)
{
    glMatrixMode(GL_MODELVIEW);
    glLoadIdentity();

    gluPerspective(90, double(width/height), 0.01, 1000);
    gluLookAt(double(m_position.x),
              double(m_position.y),
              double(m_position.z),
              double(m_center.x),
              double(m_center.y),
              double(m_center.z)
              , 0, 0, 1);
}

