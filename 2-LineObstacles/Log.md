This is the 2nd version.

# Actions

At this stage, the main task is to **test different scenarios** and see if there is any bugs prompt out. 

Then, modify the programme to improve the performance in terms of **accuracy, stability and response speed**. 

Lastly, prepare **presentation** to introduce algorithms used in detail at Monday's meeting.

## 1. Obstacles

 Obstacles added.
```
gridMap(2:9, 5) = 1;
```
* Think about:

  * How to find the best solution by hand-calculation and compare with the result from the programme when the map gets more and more complex?
  * TBC...

## 2. Delta(r, s) algorithm

The bug occurred.

* Can't detect obstacle at gridMap(88) and some surrounding grids when
  ```
  gridMap(9, 4:8) = 1;
  gridMap(4:9, 9) = 1;
  ```
* Check data detail in file [globalDelta.xlsx](1-Non-Obstacles/globalDelta_Bug.xlsx)

## 3. Modify pheromone evaporation rate &Delta;&tau;

Changing _&Delta;&tau;_ can improve the accuracy, which means the higher chance of returning the expected answer.
