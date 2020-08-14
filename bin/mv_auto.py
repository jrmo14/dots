#!/usr/bin/env python3
from pynput import mouse
from math import pi, sin, cos
import random
import time

screen_x = 1920
screen_y = 1080

running = True

def on_click(x, y, button, pressed):
    if pressed:
        print("CLICK")
        return False

def move_mouse(mouse_inst, x_off = 0, y_off = 0):
    i = 0
    for i in range(360):
        cur_x = sin(pi/180 * i) * screen_x / 128 + screen_x/2 + x_off + random.randint(-5, 5)
        cur_y = cos(pi/180 * i) * screen_y / 128 + screen_y/2 + y_off + random.randint(-5, 5)
        mouse_inst.position = (cur_x, cur_y)
        time.sleep(0.0001)

mouse_inst = mouse.Controller()
x_off = random.randint(-80, 80)
y_off = random.randint(-80, 80)
while running:
    print("jittering mouse")
    move_mouse(mouse_inst, x_off, y_off)
    print("moving place")
    x_off = random.randint(-20, 20)
    y_off = random.randint(-20, 20)
    if random.randint(0, 5) == 3:
        print("Clicking")
        mouse_inst.press(mouse.Button.left)
        time.sleep(0.05)
        mouse_inst.release(mouse.Button.left)
        time.sleep(0.1)
        mouse_inst.press(mouse.Button.left)
        time.sleep(0.05)
        mouse_inst.release(mouse.Button.left)


    with mouse.Events() as events:
        try:
            wait_time = 180+random.randint(-50, 80)
            print(f"Waiting {wait_time}s for event")
            event = events.get(wait_time)
        except:
            event = None
        if event is not None:
            print("Got event, exiting")
            running = False
