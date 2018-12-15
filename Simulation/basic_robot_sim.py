import turtle
import time

window = turtle.Screen()
robot = turtle.Turtle()

acceleration = 0
velocity = 15
turnSpeed = 15
starting_time = time.time()

def fwd():
    time_run = time.time() - starting_time
    velocity = acceleration * time_run
    robot.forward(velocity)

def left():
    robot.left(turnSpeed)

def right():
    robot.right(turnSpeed)

def increaseAccel():
    global acceleration
    acceleration += 1

def startTimer():
    starting_time = time.time()

window.onkeypress(startTimer, "w")

window.onkey(fwd, "w")
window.onkey(right, "d")
window.onkey(left, "a")

window.onkey(increaseAccel, "Up")

window.listen()
window.mainloop()
