from deadzone_simulation import *
from configuration_generator import *

bl = Point(-1, -1)
tl = Point(-1,  1)
tr = Point( 1,  1)
br = Point( 1, -1)   

diag_pos = Segment(bl, tr)
diag_neg = Segment(tl, br)
left     = Segment(bl, tl)
right    = Segment(br, tr)
top      = Segment(tl, tr)
bottom   = Segment(bl, br)

intersect_testset = \
[[diag_pos, diag_neg, True], \
 [left, right, False], \
 [left, top, True], \
 [left, left, True], \
 [diag_pos, bottom, True]]

def test_intersects():
    '''Tests the intersects function'''
    n = 0
    for seg1, seg2, res in intersect_testset:
        if(seg1.intersects(seg2) != res):
            print("test_intersects : failure in test number", n, res, "expected.")
        n += 1

test_intersects()
print("test_intersects passed.")

#pcb_position_list = \
#[[0,     125,   0 ], \
# [-64.82, 64.82, 45], \
# [-58.33, 0, 90], \
# [-17.86, -17.86, 135], \
# [0, -108.33, 180], \
# [53.03, -53.03, -135], \
# [41.61, 0, -90], \
# [5.89, 5.89, -45]]
#
left = Point(-30, -250 - 400)
right = Point(30, -250 - 400)

#led_list, pcb_list = generate_configuration(pcb_position_list,True)

#led_list, pcb_list = stairs(40, 250)

#led_list, pcb_list = symmetric_spiral_const_angle(40, 250)

#led_list, pcb_list = asymmetric_spiral_const_angle(40, 250)

#led_list, pcb_list  = asymmetric_spiral_const_dist(40, 250, 10)

led_list, pcb_list = modulo_forest(20, 250, 3)

#led_list, pcb_list = generate_configuration([[0, 200, 0]], False, True)

display_config(led_list, left, pcb_list)

compute_and_display(led_list, pcb_list, 128,  left, right)
