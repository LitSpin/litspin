#ifndef CAMERA_H
#define CAMERA_H


#include <glm/glm.hpp>
#include <glm/gtc/matrix_transform.hpp>
#include <glm/gtc/type_ptr.hpp>
#include <QKeyEvent>


class Camera
{
public:

    Camera();
    Camera(glm::vec3 position, glm::vec3 pointCible, glm::vec3 axeVertical);
    ~Camera();

    void orienter(int xRel, int yRel);
    void deplacer(QKeyEvent * event);
    void lookAt(glm::mat4 &modelview);


private:
    float m_phi;
    float m_theta;
    glm::vec3 m_orientation;

    glm::vec3 m_axeVertical;
    glm::vec3 m_deplacementLateral;

    glm::vec3 m_position;
    glm::vec3 m_pointCible;
};

#endif // CAMERA_H
