import itertools
from random import random
from math import sqrt
N_ok=0
n=10000000
for i in itertools.repeat(None,n):
        x=random()
        y=random()

        if sqrt(x**2 + y**2) <= 1:
            N_ok+=1
pi= 4.0 * N_ok / n

print "No. of points inside the circle: ", N_ok
print "Pi: ", pi

~                                                                               
~                                                                               
~                                                                               
~                                                                               
~           
