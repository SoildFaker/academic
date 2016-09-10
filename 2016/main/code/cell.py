import numpy as np
import matplotlib.pyplot as plt
import getopt,sys
from matplotlib.animation import FuncAnimation
import random
import Tkinter as tk
import math
import map_da

class Car(object):
    def __init__(self, acc, pos, des, vector, max_vec, length, face):
        self.vector = vector
        self.acc = acc
        self.length = length
        self.pos = list(pos)
        self.des = list(des)
        self.face = face
        self.max_vec = max_vec

    def turn_left(self):
        if self.face < 3:
            self.face += 1
        else:
            self.face = 0

    def turn_right(self):
        if self.face > 0:
            self.face -= 1
        else:
            self.face = 3

    def drive(self):
        if self.vector < self.max_vec:
            self.vector += self.acc
        else:
            self.vector = self.max_vec
        if self.face == 0:
            self.pos[0] += 1
        elif self.face == 1:
            self.pos[1] += 1
        elif self.face == 2:
            self.pos[0] -= 1
        elif self.face == 3:
            self.pos[1] -= 1


    def stop(self):
        self.vector = 0

class Map(object):
    def __init__(self, car_num, map_data):
        self.car_num = car_num
        self.map_data = map_data
        self.y_len = len(map_data[0])
        self.x_len = len(map_data)
        self.car_num = 0
        self.cars = []
        self.car_pos = []
        self.in_pos = []
        self.out_pos = []

    def init(self):
        for y in range(self.y_len):
            for x in range(self.x_len):
                if self.map_data[x][y]==-1:
                    self.in_pos.append([x,y])
                    self.map_data[x][y]=0
                if self.map_data[x][y]==-2:
                    self.out_pos.append([x,y])
                    self.map_data[x][y]=0

    def run(self):
        rand = random.randint(0,100)
        if rand < 25:
            if self.map_data[self.in_pos[0][0]][self.in_pos[0][1]]==0:
                self.cars.append(Car(0.1,self.in_pos[0],self.out_pos[0],3,7,3,1))
        elif rand < 50:
            if self.map_data[self.in_pos[1][0]][self.in_pos[1][1]]==0:
                self.cars.append(Car(0.1,self.in_pos[1],self.out_pos[0],3,7,3,0))
        for car in self.cars:
            car.drive()

    def plot(self):
        from PIL import Image, ImageDraw
        img = Image.new("RGB",(self.y_len*5,self.x_len*5),(0,0,0))
        draw = ImageDraw.Draw(img)
        for i in range(100): self.run()
    
        for y in range(self.y_len):
            for x in range(self.x_len):
                if self.map_data[x][y]<=0: draw.rectangle((y*5,x*5,y*5+5,x*5+5),(255,255,255))
        for car in self.cars:
            x = car.pos[0]
            y = car.pos[1]
            draw.rectangle((y*5,x*5,y*5+5,x*5+5),(0,0,255))
        img.show() 

 
    def stop(self):
        pass
map1 = Map(50,map_da.map_data)
map1.init()
map1.plot()
