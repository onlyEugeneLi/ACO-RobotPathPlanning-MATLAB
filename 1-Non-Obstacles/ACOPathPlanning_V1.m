% Title: Ant Colony Optimisation algorithms for Robot Path Planning
% Author: Yujin Li
% Date: Sunday 13 March 2022
clc;
clear all;
close all;
% 1. INITIALISATION
% 1.1. Environment
SIZE = 10;
gridMap = zeros(SIZE); % Environment configuration: 0 for clear path, 1 for obstacles
% 1.2. Parameters:
% pheromone, delta pheromone: inverse of the total path length, 
% heuristic values, number of ants, generations of ants, Alpha: evaporation 
% rate, Beta: relative importance of pheromone versus distance
numAnts = 17; % the number of ants in a colony
numGen = 20; % the number of generations (iterations)
tau = ones(SIZE*SIZE); % Pheromone Matrix Tau(r,s): amount of pheromone on 
                       % the edge from grid r to grid s. In this case, the 
                       % first column represents all the grid r and the 
                       % first row represents all the grid s, where s must 
                       % belong to J_k(r), which is a set of cities that 
                       % remain to be visited by ant k positioned on city r

tau = 8.*tau;          % Set the initial pheromone of all edges (r,s) as 8
alpha = 0.3;           % the Evaporation rate of pheromone
beta = 7;              % the relative importance beta
home = 1;              % the starting point -- home of the robot
destination = SIZE*SIZE; % destination location
minTourLength = inf;   % the length of the shortest path
bestGen = 0;           % the generation that finds the shortest path
bestAnt = 0;           % the ant that finds the shortest path within current generation
globalDelta = delta_r2s(gridMap); % cost required from r to s
% T_delta = table(globalDelta);
% writetable(T_delta, 'globalDelta.xlsx', 'sheet', 1, 'Range', 'A1');
eta = zeros(SIZE);     % Heuristic value Matrix Eta(r,s), s belongs to J_k(r)
eta = calcHeuristic(eta, destination); % Initialise Heuristic value
% T_eta = table(eta);
% writetable(T_eta, 'eta.xlsx', 'Sheet', 1, 'Range', 'A1');
% edge = 1;              % the size of the square grid( the length of the edge)
pathStorage = cell(numGen, numAnts);
pathLength = zeros(numGen, numAnts);

% 2. STATE TRANSITION
% 2.1 Initialisation
for Gen = 1:numGen     % Outter Loop: How many times ants go out and forage
    for Ant = 1:numAnts % Inner Loop: How many ants each time
		currGrid = home; % Store the current grid where the ant is located
		pathRecord = home; % Store the grids that the ant has walked through
		toBeVisited = ones(SIZE); % cities that remain to be visited by ant 
                                  % k positioned on city r; 0 for visited, 
                                  % 1 for to be visited
		toBeVisited(currGrid) = 0; % Mark the home grid as visited so it won't repeat
        localDelta = globalDelta;
		indexDelta = indexing(localDelta, currGrid, toBeVisited); % find indices of local available surrounding grids
		numAvailable = length(indexDelta); % the total number of the local available grids < 8
        counter = 1;
% 2.2 The ant start finding path to destination
        while (currGrid ~= destination && numAvailable >= 1)
% 2.2.1 Calculate the probability of choosing the certain grids based on
% tau and eta
            stateTransProb = zeros(numAvailable, 1);
            for i = 1: numAvailable
                stateTransProb(i) = tau(currGrid, indexDelta(i)) * eta(indexDelta(i))^beta;
            end
            sumProb = sum(stateTransProb);
            stateTransProb = stateTransProb / sumProb;
% 2.2.2 Roulette wheel selection algorithm: to choose the next grid randomly
            wheelProb = zeros(numAvailable, 1);
            wheelProb(1) = stateTransProb(1);
            for i = 2:numAvailable
                if i ~= numAvailable
                    wheelProb(i) = wheelProb(i-1) + stateTransProb(i);
                else
                    wheelProb(numAvailable) = 1;
                end
            end
            wheelHand = find(wheelProb >= rand, 1); % Turn the wheel and wait for the result
            nextGrid = indexDelta(wheelHand(1)); % Decide the next grid
% 2.2.3 Store the result: the new grid, the updated length
            pathRecord(end + 1) = nextGrid; % Concatenate the new grid
            pathLength(Gen, Ant) = pathLength(Gen, Ant) + localDelta(currGrid, nextGrid);
            currGrid = nextGrid; % Move to the next grid
% 2.2.4 Update J_k(r) and corresponding localDelta to prepare for the next move
            toBeVisited(currGrid) = 0;
            for i = 1:size(localDelta, 1)
                if toBeVisited(i) == 0
                    localDelta(currGrid, i) = 0;
                    localDelta(i, currGrid) = 0;
                end
            end
            indexDelta = indexing(localDelta, currGrid, toBeVisited);
            numAvailable = length(indexDelta);
            counter = counter + 1;
        end % the ant reaches to the destination and stop the loop
% 2.3 Record the job done by the ant
        pathStorage{Gen, Ant} = pathRecord; % Save the path
        if pathRecord(end) == destination
            if pathLength(Gen, Ant) < minTourLength % Does the ant find a shorter path?
                minTourLength = pathLength(Gen, Ant); % Yes, save the new shortest path
                bestGen = Gen; % Remember the generation that achieved this
                bestAnt = Ant; % Remember the ant that achieved this
            end
        else % When the ant is not successful, offset its length in this iteration
            pathLength(Gen, Ant) = 0;
        end
    end % The ant finishes the forage this time
% 2.4 Update the intensity of pheromone on the path
    deltaTau = zeros(size(tau));
    for i = 1: numAnts
        if pathLength(Gen, Ant)
            pathTemp = pathStorage{Gen, Ant};
            pathInterval = length(pathTemp) - 1;
            for j = 1: pathInterval
                deltaTau(pathTemp(j), pathTemp(j + 1)) = 1 / pathLength(Gen, Ant);
                deltaTau(pathTemp(j + 1), pathTemp(j)) = 1 / pathLength(Gen, Ant);
            end
        end
    end
    tau = (1 - alpha) .* tau + deltaTau; % pheromone evaporation rule
end % All the ants in this generation finished forage; restart a new generation now

% 3. VISUALISATION
 showPath(gridMap,SIZE, pathStorage, bestGen, bestAnt);
