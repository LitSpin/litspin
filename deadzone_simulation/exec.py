#
# This file gives several examples of configurations that can be used.
# Change the comments to chose another configuration.
# Executing this file will launch the simulation, display the chosen configuration and the result.
#

from configuration_generator import *
from deadzone_simulation     import *

NB_PCB = 20
ANGULAR_RESOLUTION = 128
DIAMETER = 250 #mm

# Left and right eyes position
left = Point(-30, -DIAMETER - 400)
right = Point(30, -DIAMETER - 400)


# Configurations

#led_list, pcb_list = stairs(NB_PCB, DIAMETER)

#led_list, pcb_list = symmetric_spiral_const_angle(NB_PCB, DIAMETER)

#led_list, pcb_list = asymmetric_spiral_const_angle(NB_PCB, DIAMETER)

#led_list, pcb_list  = asymmetric_spiral_const_dist(NB_PCB, DIAMETER, 10)

led_list, pcb_list = modulo_forest(NB_PCB, DIAMETER, 3)

#led_list, pcb_list = generate_configuration([[0, 200, 0]], False, True)


# Execution

display_config(led_list, left, pcb_list)

compute_and_display(led_list, pcb_list, ANGULAR_RESOLUTION,  left, right)
