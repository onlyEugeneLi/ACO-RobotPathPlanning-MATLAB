# Changelog

This week, I should finalise the experiment model.

## 🔖 To-do list updated on [25-03-2022]

* Learn from the working example code
* ✔️ Resolve the flawed condition on line 8 in ```calcDelta``` function
* ✔️Inspect pheromone update process and foraging process
* ✔️Would be helpful to check ```calcDelta``` ```ConvertXY``` ```tau``` ```deltaTau``` ```pathRecord``` ```globalDelta``` ```pathLength```
* ✔️ Should expect the converge result in the end
* Analyse the map size, iterations, number of ants, relative importance, pheromone matrix to solve the convergence issue
  * Maybe it is not supposed to converge at the minimal value? just close

## 📍 [Unreleased] 

### Parameters modifications

* Q - pheromone intensity coefficient can be considered later

### Visualisation

* Pheromone intensity map - distinguish each level with a set of colours
  * Maybe show it changing along the iterations

### Compare 'Without pheromone' & 'With Pheromone'

* 📉 Shown difference on line chart: 
  * Pure lucky & guided by colony's trend

## 📖 Week 8 Meeting [21-03-2022] - Outlines
  * The ants should converge to the optimal solution in the end.
  * Try visualise the process: from arbitrarily-generated path to the pheromone-guided-generated path.
  * Try visualise pheromone change progress
  * Compare results from different sets of parameters: the number of ants, the number of iterations and pheromone evaporation rate.
  * Mann-whitney test
  * Imitate the excellent example sent by Dr Castellani

## 🆕 Update [25/03/2022]

Focused on pheromone update code.

### 🔴 Issues

* ✔️ Collision: In rare cases, robot still collides with obstacles.
  * Instead of collision, it is actually flying over to distanced grids because of wrong cost measure **&delta;** set up.
 
<a href="url"><img src="https://user-images.githubusercontent.com/69563490/160194705-6838f900-4068-4630-9995-6adbf53dbacb.png"  height="350" width="350" ></a>
|:--:| 
| *Figure 1* |

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

## 🆕 Update [26-03-2022]

Focused on fixing the **condition** of scoping down available surrounding grids in cost measure **&delta;(r, s)** function

### 🔴 Issues

* Fluctuation occurs occasionally 
  
  Parameters setting
  ```
  SIZE = 10;
  gridMap = zeros(SIZE); % Environment configuration: 0 for clear path, 1 for obstacles
  gridMap(5, 2:9) = 1;
  gridMap(9, 4:8) = 1;
  gridMap(2:9, 5) = 1;
  numAnts = 5; % the number of ants in a colony
  numGen = 200; % the number of generations (iterations)
  ```
  
<a href="url"><img src="https://user-images.githubusercontent.com/69563490/160236214-31d13ecd-4f46-41e4-9dbd-a2a97ce26cf8.jpg"  height="350" width="360" ></a>
|:--:| 
| *Figure 2* |

<a href="url"><img src="https://user-images.githubusercontent.com/69563490/160236215-39e162ff-3521-4e80-b7d0-0d6e78f57730.jpg"  height="350" width="360" ></a>
|:--:| 
| *Figure 3* |


When ```numAnts = 10; numGen = 200; ```:
<a href="url"><img src="https://user-images.githubusercontent.com/69563490/160236761-4aff3691-0702-4ac1-828d-71ef25940646.jpg"  height="350" width="360" ></a>
|:--:| 
| *Figure 4* |

* Not converge to the minimal path length when increasing the iterations

```numAnts = 50; numGen = 100; alpha = 0.4```
![issueConverge](https://user-images.githubusercontent.com/69563490/160237959-503e4642-ba08-4c3f-a278-977c8cc69b9d.jpg)

```numAnts = 50; numGen = 200; ```
![issueNotConverge](https://user-images.githubusercontent.com/69563490/160237977-ffde265e-aa4d-49d5-bd44-2d688664bc09.jpg)

* Fluctuate when relative importance of pheromone are less
   Could not converge
   ``` 
   numAnts = 10; numGen = 100; alpha = 0.4; beta = 7;
   ...
   stateTransProb(i) = tau(indexDelta(i)) * eta(indexDelta(i))^beta; 
   ``` 
  * Potential sources:
    Pheromone evaporation rule; 


### 👨‍🔧 Actions

* Modified conditions (line 8) of recognising surrounding grids in function ```calcDelta(arr)```
  * Before update: 
    ```
    if arr(j) == 0 && (abs(i - j) == 11 || abs(i - j) == 10 || abs(i - j) == 9 || abs(i - j) == 1)
    ```
    Such condition will not only select out surrounding grids, but also grids on the both end of each column, causing issues of fake collision (or flying to the other end) shown in _Figure 1_ in **Issue [25-03-2022]** section.
    
  * After update:
    ```
    if arr(j) == 0 && (abs(i - j) == 11 || abs(i - j) == 10 || abs(i - j) == 9 || abs(i - j) == 1)
    [xi, yi] = ConvertXY(i, row);
    [xj, yj] = ConvertXY(j, row);
    dis = sqrt((xi - xj)^2 + (yi - yj)^2); % Check the distance
       if dis <= sqrt(2) % Make sure it's surrouding the current grid
           D(i, j) = dis; % sqrt((x1 - x2)^2 + (y1 - y2)^2);
           D(j, i) = dis; % sqrt((x1 - x2)^2 + (y1 - y2)^2);
       end
    end
    ```
  * Updated results
  
  Surprisingly, the convergence issue has been solved after solving the fake collision issue.
  
``` numAnts = 20; numGen = 50;```
<a href="url"><img src="https://user-images.githubusercontent.com/69563490/160237023-cd5970cd-aba7-4039-917d-6441cc0e12ff.jpg"  height="350" width="360" ></a>
|:--:| 
| *Figure 5* |

<a href="url"><img src="https://user-images.githubusercontent.com/69563490/160237273-ade0080c-a12d-42b5-9f3d-a84d516946d5.jpg"  height="350" width="360" ></a>
|:--:| 
| *Figure 6* |

``` numAnts = 50; numGen = 100; ```
<a href="url"><img src="https://user-images.githubusercontent.com/69563490/160237213-cb8a038a-f284-42b2-a314-cc0287806c7e.jpg"  height="350" width="360" ></a>
|:--:| 
| *Figure 7* |

* Changed relative importance

Works better
``` 
numAnts = 10; numGen = 100; alpha = 0.4; beta = 7;
...
stateTransProb(i) = tau(indexDelta(i))^5 * eta(indexDelta(i))^beta; 
``` 
Result:

<a href="url"><img src="https://user-images.githubusercontent.com/69563490/160238186-ae0f6a43-096f-4dd1-9d04-ba2f65be293b.jpg"  height="350" width="360" ></a>
|:--:| 
| *Figure 8* |

Could not converge
``` 
numAnts = 10; numGen = 100; alpha = 0.4; beta = 7;
...
stateTransProb(i) = tau(indexDelta(i)) * eta(indexDelta(i))^beta; 
``` 
Result:

<a href="url"><img src="https://user-images.githubusercontent.com/69563490/160238252-097466f6-45b9-460e-91a7-fc77aacc71e1.jpg"  height="350" width="360" ></a>
|:--:| 
| *Figure 9* |

* Modified relative importance making pheromone more important than heuristic value
  * It can converge now
  * How does the example work with heuristic value more important than pheromone??


### Questions

* 报告花多少时间
* 有些情况会出问题
* 怎样写好报告
* 本科毕设需要提出创新的点吗？从什么角度入手比较好
