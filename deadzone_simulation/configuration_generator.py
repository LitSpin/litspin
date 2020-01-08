import numpy as np
from deadzone_simulation import *

PCB_WIDTH = 8 #mm
LED_ELEVATION = 1.9 #mm
L_WIDTH   = 5 #mm

def generate_configuration(pcb_position_list, polar, double_side = False, L_enabled = False):
    '''
    Generates segments and leds from a PCB position list (x, y , angle)
    '''
    led_list = []
    pcb_list = []
    coord_list = []
    for x, y, theta in pcb_position_list:
        if polar:
            r = x
            t = y * np.pi / 180
            x = r * np.cos(t)
            y = r * np.sin(t)
        coord_list.append((x, y, theta))
        theta = theta * np.pi / 180
        c, s = np.cos(theta), np.sin(theta)
        a = Point(x - c * PCB_WIDTH / 2, y - s * PCB_WIDTH / 2)
        b = Point(x + c * PCB_WIDTH / 2, y + s * PCB_WIDTH / 2)
        pcb = Segment(a, b)
        pcb_list.append(pcb)
        
        led = Led(x - s * LED_ELEVATION, y + c * LED_ELEVATION, theta + np.pi / 2)
        led_list.append(led)
        
        if double_side:
            led = Led(x + s * LED_ELEVATION, y - c * LED_ELEVATION, theta + np.pi * 3/2)
            led_list.append(led)

        if L_enabled:
            ll_a = Point(a.x - s * L_WIDTH / 2, a.y + c * L_WIDTH / 2)
            ll_b = Point(a.x + s * L_WIDTH / 2, a.y - c * L_WIDTH / 2)
            lr_a = Point(b.x - s * L_WIDTH / 2, b.y + c * L_WIDTH / 2)
            lr_b = Point(b.x + s * L_WIDTH / 2, b.y - c * L_WIDTH / 2)
            pcb_list.append(Segment(ll_a, ll_b))
            pcb_list.append(Segment(lr_a, lr_b))

    print(coord_list)
    return led_list, pcb_list

def stairs(nb_pcb : int, diameter : float):
    dist = 2 * diameter / (nb_pcb - 1)
    nb_steps = nb_pcb // 2
    pcb_position_list = [[dist / 2 + n * dist , 0, 45 if n % 2 == 0 else -45] for n in range(nb_steps)]
    pcb_position_list_symmetry = []
    for x, y, theta in pcb_position_list:
        pcb_position_list_symmetry.append([-x, 0, -45 if theta == 45 else 45])
    fig=pypl.figure()
    return generate_configuration(pcb_position_list + pcb_position_list_symmetry, False, False)

def symmetric_spiral_const_angle(nb_pcb : int, diameter: float):
    angle = 360 / nb_pcb
    dist = diameter / nb_pcb
    pcb_position_list = [[dist / 2 + n * dist, n * angle, n * angle - 90] for n in range(nb_pcb // 2)]
    pcb_position_symmetric = []
    for r, t, theta in pcb_position_list:
        pcb_position_symmetric.append([r, 180 + t, theta])
    return generate_configuration(pcb_position_list + pcb_position_symmetric, True, False)

def asymmetric_spiral_const_angle(nb_pcb : int, diameter: float):
    angle = 360 / nb_pcb
    dist = diameter / nb_pcb
    pcb_position_list = [[dist / 2 + n * dist, n//2 * angle + (180 if n%2 == 0 else 0), n//2 * angle - 90] for n in range(nb_pcb)]
    return generate_configuration(pcb_position_list, True, True)

def asymmetric_spiral_const_dist(nb_pcb : int, diameter : float, dist : float):
    pcb_position_list = []
    delta_r = diameter / nb_pcb
    r = delta_r / 2
    t = 0
    for n in range(nb_pcb // 2):
        pcb_position_list.append([r, t, t + 90])
        r = r + 2 * delta_r
        t = t + (dist / r) * 180 / np.pi
    r = delta_r * 3/2
    pcb_position_symmetric = []
    for pcb in pcb_position_list:
        t = pcb[1]
        pcb_position_symmetric.append([r, t + 180, t + 90])
        r = r + 2 * delta_r
    return generate_configuration(pcb_position_list + pcb_position_symmetric, True, True)

def modulo_forest(nb_pcb : int, diameter : float, gap : int):
    angle = 360 / nb_pcb
    dist = (diameter / 2) / nb_pcb
    pcb_position_list = [[n * dist + dist / 2, n * gap * angle, n * gap * angle + 90] for n in range(nb_pcb)]
    return generate_configuration(pcb_position_list, True, True, True)
