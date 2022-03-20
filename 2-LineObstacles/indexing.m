function index = indexing(delta, grid, J_kr) % Return the indices of available grids
    index = delta(grid, :); % Store the cost required to the next gird
	arr = find(index); % Scope down available adjacent grids indices; store the complete indices
    % Double check for visited grids to avoid self-repeating
    for i = 1: length(arr)
		if J_kr(arr(i)) == 0 
			index(arr(i)) = 0;
        end
        % What about excluding obstacles? grids == 1?
        % Why is the path going straight down? while heuristic value are 
    end
    index = find(index);
end

