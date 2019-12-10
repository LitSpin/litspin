# Deadzone simulator

This program modelizes a PCB configuration in 2D and computes the visibility of points of space in a 3D POV display, taking into account two phenomena:
* PCBs hiding each other
* The variation of viewing LED viewing angle

## Principle

This simulator uses simple plane geometry.
PCBs hiding each other is computed using segment intersection tests.
The variation of viewing angle is computed using the vector dot product.

## Implementation

Two files:
* `configuration_generator.py` allows to easily generate the geometry of a configuration
* `deadzone_simulation.py` contains the algorithm itself

## Execution

`exec.py` contains an example of usage of the simulator. It can be executed or edited to change the used configuration.
