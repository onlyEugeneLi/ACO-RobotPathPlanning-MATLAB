# Changelog

This week, I should finalise the experiment model.

## 🔖 To-do list updated on [25-03-2022]

* Learn from the working example code
* Resolve the flawed condition on line 8 in ```calcDelta``` function
* Inspect pheromone update process and foraging process
* Would be helpful to check ```calcDelta``` ```ConvertXY``` ```tau``` ```deltaTau``` ```pathRecord``` ```globalDelta``` ```pathLength```
* Should expect the converge result in the end

## 📍 [Unreleased] 

### Parameters modifications

* Q - pheromone intensity coefficient can be considered later

### Visualisation ideas

* Pheromone intensity map - distinguish each level with a set of colours
  * Maybe show it changing along the iterations

## 📖 Week 8 Meeting [21-03-2022] - Outlines
  * The ants should converge to the optimal solution in the end.
  * Try visualise the process: from arbitrarily-generated path to the pheromone-guided-generated path.
  * Try visualise pheromone change progress
  * Compare results from different sets of parameters: the number of ants, the number of iterations and pheromone evaporation rate.
  * Mann-whitney test
  * Imitate the excellent example sent by Dr Castellani

## Update [25/03/2022]

Focused on pheromone update code.

### 🔴 Issues

* Collision: In rare cases, robot still collides with obstacles.
  * Instead of collision, it is actually flying over to distanced grids because of wrong cost measure **&delta;** set up.
 
<a href="url"><img src="https://user-images.githubusercontent.com/69563490/160194705-6838f900-4068-4630-9995-6adbf53dbacb.png"  height="350" width="350" ></a>

When I changed the code to... (Though that's not the key point)
```
tau = ones(SIZE);
tau = 10.*tau;          % Set the initial pheromone of all edges (r,s) as 8
alpha = 0.4;           % the Evaporation rate of pheromone
```

* Pheromone matrix **&tau;** updates abnormally
  * Only grid 1 was updated when other grids in **&Delta;&tau;** remain zero


### 👨‍🔧 Actions

* Checked ``` tau ``` and ``` deltaTau ``` data
  * Only grid 1 in ``` deltaTau ``` has value; Grid 1 in ``` tau ``` was 16.2298
  * Why is only grid 1 updated while the entire path should be passed new values?


* Changed line 118 from ``` for j = 1: size(pathTemp)``` to ``` for j = 1: length(pathTemp) ```
  * pheromone matrix **&tau;** seems normal now

* Collision issue
  * Checked ```pathRecord``` to see the path trail and ```globalDelta``` to see the available grids
  * Checked ```calDelta``` function: the condition logic is flawe
     
     calDelta function line 8:
     ```
     if arr(j) == 0 && (abs(i - j) == 11 || abs(i - j) == 10 || abs(i - j) == 9 || abs(i - j) == 1)
     ```
     ❗ abs(i - j) == 10 and abs(i - j) == would recognise girds at the other end of the same column by mistake.
