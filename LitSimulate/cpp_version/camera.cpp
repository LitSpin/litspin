#include "camera.h"
#include <iostream>

Camera::Camera() : m_phi(0.0), m_theta(0.0), m_orientation(), m_axeVertical(0, 0, 1), m_deplacementLateral(), m_position(), m_pointCible()
{

}
Camera::Camera(glm::vec3 position, glm::vec3 pointCible, glm::vec3 axeVertical) : m_phi(0.0), m_theta(0.0), m_orientation(), m_axeVertical(axeVertical),
                                                                          m_deplacementLateral(), m_position(position), m_pointCible(pointCible)
{

}
Camera::~Camera()
{

}
void Camera::orienter(int xRel, int yRel)
{
    // Récupération des angles

    m_phi += -yRel * 0.5f;
    m_theta += -xRel * 0.5f;


    // Limitation de l'angle phi

    if(m_phi > 89.0f)
        m_phi = 89.0f;

    else if(m_phi < -89.0f)
        m_phi = -89.0;


    // Conversion des angles en radian

    float phiRadian = m_phi * float(M_PI) / 180;
    float thetaRadian = m_theta * float(M_PI) / 180;


    // Si l'axe vertical est l'axe X

    if(m_axeVertical.x == 1.0f)
    {
        // Calcul des coordonnées sphériques

        m_orientation.x = sinf(phiRadian);
        m_orientation.y = cosf(phiRadian) * cosf(thetaRadian);
        m_orientation.z = cosf(phiRadian) * sinf(thetaRadian);
    }


    // Si c'est l'axe Y

    else if(m_axeVertical.y == 1.0f)
    {
        // Calcul des coordonnées sphériques

        m_orientation.x = cosf(phiRadian) * sinf(thetaRadian);
        m_orientation.y = sinf(phiRadian);
        m_orientation.z = cosf(phiRadian) * cosf(thetaRadian);
    }


    // Sinon c'est l'axe Z

    else
    {
        // Calcul des coordonnées sphériques

        m_orientation.x = cosf(phiRadian) * cosf(thetaRadian);
        m_orientation.y = cosf(phiRadian) * sinf(thetaRadian);
        m_orientation.z = sinf(phiRadian);
    }


    // Calcul de la normale

    m_deplacementLateral = cross(m_axeVertical, m_orientation);
    m_deplacementLateral = normalize(m_deplacementLateral);


    // Calcul du point ciblé pour OpenGL

    m_pointCible = m_position + m_orientation;
}

void Camera::deplacer(QKeyEvent * event)
{

        if(event->key() == Qt::Key_Z){
            std::cout<<"z"<<std::endl;
            m_position = m_position + m_orientation *0.5f;
            m_pointCible = m_position + m_orientation;
        }

        // Recul de la caméra

        if(event->key() == Qt::Key_S)
        {
            std::cout<<"s"<<std::endl;
            m_position = m_position - m_orientation * 0.5f;
            m_pointCible = m_position + m_orientation;
        }


        // Déplacement vers la gauche

        if(event->key() == Qt::Key_Q)
        {
            std::cout<<"q"<<std::endl;
            m_position = m_position + m_deplacementLateral * 0.5f;
            m_pointCible = m_position + m_orientation;
        }


        // Déplacement vers la droite

        if(event->key() == Qt::Key_D)
        {
            std::cout<<"d"<<std::endl;
            m_position = m_position - m_deplacementLateral * 0.5f;
            m_pointCible = m_position + m_orientation;
        }

}

void Camera::lookAt(glm::mat4 &modelview)
{
    // Actualisation de la vue dans la matrice

    modelview = glm::lookAt(m_position, m_pointCible, m_axeVertical);
}
