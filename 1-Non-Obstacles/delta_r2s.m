function D = delta_r2s(arr) % delta_(r,s): cost from grid r to grid s
                                % r and s must be next to each other ssss
    row = size(arr, 1);         % the number of rows of the array 
    column = size(arr, 2);
    D = zeros(row*column);     % initialise the delta_(r,s) matrix
    % Outer Loop
    for i = 1:row               
        for j = 1:column           % Outter Loop: Traverse all the grids to set their cost 
                                % of traveling to the local surrouding grids
            if arr(i, j) == 0   % grid r must not be a obstacle
                
                % Inner Loop
                for x = 1:row
                    for y = 1:column % Inner Loop: find the surrounding available 
                                     % grids s and return the cost value
                                     % (distance) to the exact variable in
                                     % the matrix
                        if arr(x, y) == 0 % the surrounding grid must be clear
                            rel_x = abs(i - x); % relative distance between grid r and s on x direction
                            rel_y = abs(j - y); % relative distance between grid r and s on y direction
                            if rel_x + rel_y == 1 || (rel_x == 1 && rel_y == 1)
                                % When this grid is one of the adjacent
                                % grids in 8 directions
                                D((i-1)*column + j, (x-1)*column + y) = sqrt(rel_x^2 + rel_y^2); 
                                % D(r, s), r and s are indices of one-dimensional matrix
                                % Return relative distance between r and s
                            end
                        end
                    end
                end
            end
        end
    end

end

