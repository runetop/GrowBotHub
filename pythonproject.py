from ortools.sat.python import cp_model
import numpy as np
import os
from random import randint

#

nTrays = 4 # Number of trays
nPlants = 50 # Number of plants that we want to schedule (not the number of different types)
nSlotsPerTray = 8 # Number of place per tray for plants

trays = list(range(nTrays)) # Some convenience names


class PlantData:
    def __init__(self, calories, growTimePerTray):
        self.calories = calories
        self.growTimePerTray = growTimePerTray
    def __repr__(self):
        return f"Plant worth {self.calories} calories with growth time {sum(self.growTimePerTray)} (cycle {self.growTimePerTray})"
		
		
		
		
# Specify the data about the types of plants here

# PlantData(calories, [growtime per tray])
plantData = [
	PlantData(120, [10,20,30,20]),
	PlantData(230, [20,21,10,10]),
	PlantData(150, [42,26,40,20]),
	PlantData(400, [35,50,52,23]),
	PlantData(100, [51,50,20,15]),
	PlantData(170, [21,12,40,10]),
	PlantData(80, [12,10,10,50]),
]
nPlantTypes = len(plantData)

# When doing integer programming, we need to know how large all variables may possibly be. 
# We're just computing overbounds here
PlantMinGrowTimes = [[p.growTimePerTray[t] for p in plantData] for t in range(4)]
PlantCalories = [p.calories for p in plantData]
maxGrowTime = nPlants * 400
maxCalories = max(PlantCalories)

# Creates the model.
m = cp_model.CpModel()

class Plant:
    def __init__(self, name, model):
        self.name = name
        self.Tstart = [model.NewIntVar(0, maxGrowTime, f"{name}_{t}_Tstart") for t in trays]
        self.duration = [model.NewIntVar(0, maxGrowTime, f"{name}_{t}_duration") for t in trays]
        self.Tend = [model.NewIntVar(0, maxGrowTime, f"{name}_{t}_Tend") for t in trays]
        self.Interval = [model.NewIntervalVar(self.Tstart[t], self.duration[t], self.Tend[t], f"{name}_{t}") for t in trays]
        self.minGrowTime = [model.NewIntVar(0, maxGrowTime, f"{name}_{t}_minGrowTime") for t in trays]
        # The type of the plant, from PlantData
        self.type = model.NewIntVar(0, nPlantTypes, 'type')
        self.calories = model.NewIntVar(0, maxCalories, f"{name}_calories")
        # Constrain the time in each tray to be long enough
        for tray, duration in enumerate(self.duration):
            model.AddElement(self.type, PlantMinGrowTimes[tray], self.minGrowTime[tray])
            model.Add(self.duration[tray] >= self.minGrowTime[tray])
        # Go through the trays in order
        for tray in range(nTrays - 1):
            model.Add(self.Tstart[tray + 1] == self.Tend[tray])
        # Calories for this plant
        model.AddElement(self.type, PlantCalories, self.calories)

# Create the number of requested plant objects
plants = [Plant(f"plant_{i}", m) for i in range(nPlants)]
m.Add(plants[0].type==0)
m.Add(plants[1].type==0)
m.Add(plants[2].type==0)
m.Add(plants[3].type==0)
m.Add(plants[4].type==1)
m.Add(plants[5].type==1)
m.Add(plants[6].type==1)
m.Add(plants[7].type==1)
m.Add(plants[8].type==1)
m.Add(plants[9].type==1)
m.Add(plants[10].type==1)
m.Add(plants[11].type==1)
m.Add(plants[12].type==1)
m.Add(plants[13].type==1)
m.Add(plants[14].type==1)
m.Add(plants[15].type==1)
m.Add(plants[16].type==1)
m.Add(plants[17].type==1)
m.Add(plants[18].type==1)
m.Add(plants[19].type==1)
m.Add(plants[20].type==1)
m.Add(plants[21].type==1)
m.Add(plants[22].type==1)
m.Add(plants[23].type==1)
m.Add(plants[24].type==1)
m.Add(plants[25].type==1)
m.Add(plants[26].type==1)
m.Add(plants[27].type==1)
m.Add(plants[28].type==1)
m.Add(plants[29].type==1)
m.Add(plants[30].type==1)
m.Add(plants[31].type==1)
m.Add(plants[32].type==1)
m.Add(plants[33].type==1)
m.Add(plants[34].type==2)
m.Add(plants[35].type==2)
m.Add(plants[36].type==2)
m.Add(plants[37].type==2)
m.Add(plants[38].type==2)
m.Add(plants[39].type==2)
m.Add(plants[40].type==2)
m.Add(plants[41].type==2)
m.Add(plants[42].type==2)
m.Add(plants[43].type==2)
m.Add(plants[44].type==2)
m.Add(plants[45].type==2)
m.Add(plants[46].type==5)
m.Add(plants[47].type==5)
m.Add(plants[48].type==5)
m.Add(plants[49].type==5)

# This constraint says that each plant takes up one slot in the tray, and that we have nSlotsPerTray available
# It then ensures that the growing intervals of the plant don't violate the number of slots available
for tray in trays:
    intervals = [p.Interval[tray] for p in plants]
    demands = [1 for p in plants]
    m.AddCumulative(intervals, demands, nSlotsPerTray)	
    solver = cp_model.CpSolver()

total_calories = sum(p.calories for p in plants)
total_growtime = max(p.Tend[-1] for p in plants)
m.Maximize(5 * total_calories - 10 * total_growtime)
status = solver.Solve(m)

f=open("C:\\Users\\tomqu\\Desktop\\projet bachelor\\data_sheet.txt","w+")

print(solver.StatusName(status))
print(f"Solution: calories {solver.Value(total_calories)}, growtime {solver.Value(total_growtime)}")

f.write(f"Solution: calories {solver.Value(total_calories)}, growtime {solver.Value(total_growtime)}")

f.close()

import matplotlib.pyplot as plt
# plt.rcParams['figure.figsize'] = [10, 5]
plt.rcParams['figure.dpi'] = 200

fig, gnt = plt.subplots()


gnt.axes.get_yaxis().set_ticks([])

gnt.set_xlabel('Time')
gnt.set_ylabel('Plants')

#gnt.set_yticks([15, 25, 35])
#gnt.set_yticklabels(['1', '2', '3'])

gnt.grid(True)

height = 10
colors = ('tab:orange', 'tab:blue', 'tab:green', 'tab:red')
for p in plants:
    for t in trays:
        sched = [(solver.Value(p.Tstart[t]), solver.Value(p.duration[t]))]
        gnt.broken_barh(sched, (height, 8), facecolors = colors[t])
    height = height + 10

plt.savefig('C:\\Users\\tomqu\\Desktop\\projet bachelor\\graphe1.png',format='png')

# Extract the schedule
schedule = [[[solver.Value(p.Tstart[t]), solver.Value(p.Tend[t])] for t in range(4)] for p in plants]

# Each block is the start and end time for the plant to be in each tray
emploidutemps=np.array(schedule)




growth_time = max(max(max(schedule)))
numPlants = np.zeros([growth_time, nTrays])
for t in trays:
    for i in range(growth_time):
        for p in schedule:
            if i >= p[t][0] and i < p[t][1]: # The plant is in the tray at this time
                numPlants[i, t] += 1

fig, gnt = plt.subplots()

gnt.step(range(growth_time), numPlants)

gnt.set_xlabel('Time')
gnt.set_ylabel('Number of plants in tray')

gnt.grid(True)

plt.savefig('C:\\Users\\tomqu\\Desktop\\projet bachelor\\graphe2.png',format='png')

# The plant type that each plant chose
plantTypes = np.array([solver.Value(p.type) for p in plants])
numPerType = [sum(plantTypes == i) for i in range(nPlantTypes)]

fig, gnt = plt.subplots()

gnt.bar(range(nPlantTypes), numPerType, 0.35)
gnt.set_xlabel('Plant Types')

plt.savefig('C:\\Users\\tomqu\\Desktop\\projet bachelor\\graphe3.png',format='png')

f=open("C:\\Users\\tomqu\\Desktop\\projet bachelor\\données.txt","w+")

f.write("Plantschange=[")

for p in plants :
    f.write(f"{[solver.Value(p.Tstart[0]), solver.Value(p.Tend[0]), solver.Value(p.Tend[1]), solver.Value(p.Tend[2]), solver.Value(p.Tend[3])]}; ")

f.write("]; \n ")

f.write(f"Plantsnames={[solver.Value(p.type) for p in plants]}")

f.write(";")

f.close()