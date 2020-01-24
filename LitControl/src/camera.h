#ifndef CAMERA_H
#define CAMERA_H


#include <glm/glm.hpp>
#include <glm/gtc/matrix_transform.hpp>
#include <glm/gtc/type_ptr.hpp>
#include <QKeyEvent>


class Camera
{
public:

    Camera(glm::vec3 center);

    void setPosition(float x, float y, float z);
    void setPositionSpherical(float r, float theta, float phi);

    void moveRadius(float delta);
    void moveTheta(float delta);
    void movePhi(float delta);

    void update(float width, float height);


private:
    glm::vec3 m_center;
    glm::vec3 m_position;

    float m_r;
    float m_theta;
    float m_phi;
};

#endif // CAMERA_H
