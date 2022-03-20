# ACO-RobotPathPlanning-MATLAB
Final Year Project Logs
## Update dates & details
### Ver. 17 Mar 2022
* Bug cleared
* No obstacles in the map
  ```
  numAnts = 17;
  numGen = 20;
  ```
* To ensure to find the diagonal-shortest path, deployed precedent parameters

### Ver. 20 Mar 2022
* Added obstacles to the map
  ```
  gripMap(2:9, 5) = 1;
  ```
  * Ran well, but need to improve the accuracy and stability

* Solved a fail-to-detect-obstacles issue
  * When using the Delta_r2r(arr) function, globalDelta stored obstacles in the array by mistake.
  * Bug source still not found
