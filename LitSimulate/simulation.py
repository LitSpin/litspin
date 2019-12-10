import pygame
import gc
from pygame.locals import *

from OpenGL.GL import *
from OpenGL.GLU import *

import sys
import numpy as np
import imageio
import math



theta = 0

h = 10

n,r,p=0,0,0

def R(x):
    if (x<r):
        return r-x
    else:
        return r-x-1

def print_image(image):
    glPointSize(5)
    glBegin(GL_POINTS)
    for i in range(n):
        for j in range(p):
            glColor4fv(image[i,j])
            if image[i,j,3]!=0:
                glVertex3d(R(j//h)*np.cos(i*theta), R(j//h)*np.sin(i*theta), h-j%h)

    glEnd()


def init():
    image = (imageio.imread(sys.argv[1])).astype(float)/255

    image = np.transpose(image, axes=(1,0,2))
    

    global n,p,r,theta
    n,p,_= image.shape
    r = p//h
    theta = 2*np.pi/n
    
    return image

image = init()

pygame.init()
display = (1000, 1000)
scree = pygame.display.set_mode(display, DOUBLEBUF | OPENGL)

glMatrixMode(GL_PROJECTION)
gluPerspective(45, (display[0]/display[1]), 0.1, 100.0)

glMatrixMode(GL_MODELVIEW)
gluLookAt(0, -20, 0, 0, 0, 0, 0, 0, 1)
viewMatrix = glGetFloatv(GL_MODELVIEW_MATRIX)
glLoadIdentity()

# init mouse movement and center mouse on screen
displayCenter = [scree.get_size()[i] // 2 for i in range(2)]
mouseMove = [0, 0]
pygame.mouse.set_pos(displayCenter)

up_down_angle = 0.0
paused = False
run = True
while run:
    for event in pygame.event.get():
        if event.type == pygame.QUIT:
            run = False
        if event.type == pygame.KEYDOWN:
            if event.key == pygame.K_ESCAPE or event.key == pygame.K_RETURN:
                run = False
            if event.key == pygame.K_PAUSE or event.key == pygame.K_p:
                paused = not paused
                pygame.mouse.set_pos(displayCenter) 
        if not paused: 
            if event.type == pygame.MOUSEMOTION:
                mouseMove = [event.pos[i] - displayCenter[i] for i in range(2)]
            pygame.mouse.set_pos(displayCenter)    

    if not paused:
        # get keys
        keypress = pygame.key.get_pressed()
        mousepress = pygame.mouse.get_pressed()
        
        # init model view matrix
        glLoadIdentity()

        # apply the look up and down
        glRotatef(mouseMove[1]*0.1, 1.0, 0.0, 0.0)
        # apply the movment 
        if keypress[pygame.K_z]:
            glTranslatef(0,0,1.0)
        if keypress[pygame.K_s]:
          glTranslatef(0,0,-1.0)
        if keypress[pygame.K_d]:
            glTranslatef(-1,0,0)
        if keypress[pygame.K_q]:
            glTranslatef(1,0,0)
        if mousepress[0]:
            glTranslatef(0,-1,0)
        if mousepress[2]:
            glTranslatef(0,1,0)

        if keypress[pygame.K_a]:
            glRotatef(0.5,0,0,1)
        if keypress[pygame.K_e]:
            glRotatef(0.5,0,0,-1)

        glRotatef(mouseMove[0]*0.1, 0.0, 1.0, 0.0)

        # multiply the current matrix by the get the new view matrix and store the final vie matrix 
        glMultMatrixf(viewMatrix)
        viewMatrix = glGetFloatv(GL_MODELVIEW_MATRIX)

        glClear(GL_COLOR_BUFFER_BIT|GL_DEPTH_BUFFER_BIT)

        print_image(image) 

        pygame.display.flip()
        gc.collect()

pygame.quit()