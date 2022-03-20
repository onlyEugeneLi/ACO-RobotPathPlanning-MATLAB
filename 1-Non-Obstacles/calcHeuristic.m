function Eta = calcHeuristic(arr, grid)
    dim1 = size(arr, 1);
    dim2 = size(arr, 1) * size(arr, 1);
    for i = 1:dim2
        [desti_x, desti_y] = ConvertXY(grid, dim1);
        [x, y] = ConvertXY(i, dim1);
        distance = sqrt((x - desti_x)^2 + (y - desti_y)^2);
        if i ~= grid
            arr(i) = 1 / distance;
        else
            arr(grid) = 100;
        end
    end
    Eta = arr;
end

