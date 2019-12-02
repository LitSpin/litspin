import numpy as np
import matplotlib.pyplot as pypl

#
# Inputs :
# * a point of view
# * an array of points (leds)
# * an array of segments (PCBs)
#
# Output :
# * an array of points (visible voxels)
#


MIN_DOT_SIZE = 0.1
DOT_SIZE_INCREASE = 20

EPSILON = 1e-5

class Point:
    '''Represents a point of the plane'''
    def __init__(self, x : float, y : float):
        self.x = float(x)
        self.y = float(y)

    def rotate(self, angle : float):
        '''
        rotates the point around the origin with the given angle in rad
        '''
        c, s = np.cos(angle), np.sin(angle)
        R = np.matrix([[c, s], [-s, c]])
        m = np.dot(R, [self.x, self.y])

        return Point(m.T[0], m.T[1])

    @staticmethod
    def det(a, b, c):
        return (b.x - a.x) * (c.y - a.y) - (c.x - a.x) * (b.y - a.y)

    def position(self, segment):
        '''
        returns
        * 0 if the point is on the segment
        * -1 if it is on the left of the segment
        * 1 if it is on the right of the segment
        '''
        d = Point.det(segment.a, segment.b, self)
        if abs(d) < EPSILON: return 0
        elif d < 0         : return 1
        else               : return -1

class Led(Point):
    '''Represents a LED which is a point with a direction of light'''
    def __init__(self, x : float, y : float, theta : float):
        Point.__init__(self, x, y)
        self.theta = theta
        #virtual point creates a point in the direction where the light shines
        self.virtual_point = Point(x + np.cos(theta), y + np.sin(theta))

    def visibility(self, view):
        '''Returns a percentage of visibility depending on the LED orientation compared to the view'''
        led_vector = Segment(self, self.virtual_point)
        view_vector = Segment(self, view)
        tmp = led_vector.dot(view_vector) / view_vector.length()
        return tmp if tmp > 0 else 0

class Segment:
    '''Represents a segment of the space'''
    def __init__(self, a, b):
        self.a = a
        self.b = b

    def intersects(self, other):
        '''
        checks whether or not two segments intersect
        '''
        a1, b1 = self.a, self.b

        pos_a1 = a1.position(other)
        pos_b1 = b1.position(other)
        # if a1 and b1 are in the same side of other, no intersection
        if 0 != pos_a1 == pos_b1 != 0 :  return False
        
        a2, b2 = other.a, other.b
        pos_a2 = a2.position(self)
        pos_b2 = b2.position(self)
        # if a2 and b2 are in the same side of self, no intersection
        if 0 != pos_a2 == pos_b2 != 0 : return False

        # if we are there, there is an intersection
        return True

    def length(self):
        '''returns the length of the segment'''
        return np.sqrt((self.a.x - self.b.x)**2 + (self.a.y - self.b.y)**2)

    def dot(self, other):
        '''dot product'''
        x1, y1 = self.b.x - self.a.x, self.b.y - self.a.y
        x2, y2 = other.b.x - other.a.x, other.b.y - other.a.y
        return x1*x2 + y1*y2

def hidden(led, view, pcb):
    '''
    checks if a led is hidden by a pcb from the point of view
    '''
    return pcb.intersects(Segment(led, view))

def visible(led, view, pcb_list):
    '''
    checks if a led is visible, e.g. not hidden by any pcb 
    '''
    ret = True
    for pcb in pcb_list:
        ret &= not hidden(led, view, pcb)
    return ret

def visible_leds(led_list, view, pcb_list, angle):
    '''
    returns an array of visible leds when rotated of an angle in rad
    '''
    # it is cheaper to just rotate the view
    v = view.rotate(-angle)
    visible_list = []
    for led in led_list:
        if visible(led, v, pcb_list):
            brightness = led.visibility(v)
            visible_list.append([led.rotate(angle), brightness])
    return visible_list

def compute_turn(led_list, view, pcb_list, number_of_angles : int):
    '''
    returns an array of visible leds on a turn with a given amount of angles
    '''
    visible_list = []
    angular_precision = 2. * np.pi / number_of_angles
    angle_list = [n * angular_precision for n in range(number_of_angles)]
    for angle in angle_list:
        visible_list = visible_list + visible_leds(led_list, view, pcb_list, angle)
    return visible_list

def plot_visible_points(visible_list, c = "blue"):
    '''
    Plots the points of a list.
    '''
    for led, brightness in visible_list:
        pypl.scatter([led.x], [led.y], s = MIN_DOT_SIZE + brightness * DOT_SIZE_INCREASE, color = c, alpha = 0.5)

def display_visible_points(visible_left, left, visible_right = None, right = None):
    '''
    Opens a pyplot window with the given points.
    '''
    plot_visible_points(visible_left, "blue")
    if not (visible_right is None or right is None):
        plot_visible_points(visible_right, "red")
    # center point
    #pypl.scatter([0], [0], "black")
    # point of view
    pypl.scatter([left.x], [left.y], color = "blue")
    if not right is None:
        pypl.scatter([right.x], [right.y], color = "red")
    pypl.xlim(-300, 300)
    pypl.ylim(-400,300)
    pypl.axis("scaled")
    pypl.show()

def compute_and_display(led_list, pcb_list, number_of_angles : int, left, right = None):
    '''
    Executes the algorithm and diplays the result.
    '''
    visible_left = compute_turn(led_list, left, pcb_list, number_of_angles)
    visible_right = None if right is None else compute_turn(led_list, right, pcb_list, number_of_angles)
    display_visible_points(visible_left, left, visible_right, right)

def display_config(led_list, view, pcb_list):
    '''
    Displays a PCB config.
    '''
    x_list = [led.x for led in led_list]
    y_list = [led.y for led in led_list]
    pypl.scatter(x_list, y_list, color = "blue")
    pypl.scatter([view.x], [view.y], color="red")
    pypl.scatter([0], [0], color="black")
    for pcb in pcb_list:
        pypl.plot([pcb.a.x, pcb.b.x], [pcb.a.y, pcb.b.y], color="green")
    ax=pypl.gca()
    ax.add_artist(pypl.Circle((0, 0), 260, color = "black", fill=False))
    pypl.axis("scaled")
    pypl.xlim(-300, 300)
    pypl.ylim(-400,300)
    pypl.show()
