import time
import turtle

acc = 0.05

j = 1
pos = 0
vel = 0
angle = 0.1
turtle.speed(0)
while j < 60:
	vel = j*acc
	pos = pos + vel
	print(pos)
	turtle.pendown()
	turtle.forward(vel)
	j = j + 1
time.sleep(1)
while j > 0:
	vel = j*acc
	pos = pos + vel
	print(pos)
	turtle.forward(vel)
	j = j - 1