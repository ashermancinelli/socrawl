import RPi.GPIO as gp
import time

# Variables for the min and max_range
min = 2
max = 3

# Setting up the servo
gp.setmode(gp.BOARD)
gp.setup(11, gp.OUT)

pwm = gp.PWM(11, 50)

pwm.start(5)

# Loop for a while and then stop and cleanup
for _ in range(5):
	print("vroom vroom")
	pwm.ChangeDutyCycle(min)
	time.sleep(1)
	print("skrrrrrt")
	pwm.ChangeDutyCycle(max)
	time.sleep(1)

pwm.stop()
gp.cleanup()
quit()
