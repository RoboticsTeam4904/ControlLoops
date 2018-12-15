import time
j = 0
pos = 0
vel = 0
acc = 2
while j < 10:
	vel = j*acc
	pos = pos + vel
	print(pos)
	j = j + 1