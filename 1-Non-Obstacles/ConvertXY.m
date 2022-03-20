function [x, y] = ConvertXY(gridNum, rowMap) % Extract x coordinate from the serial number of the location
    x = ceil(gridNum / rowMap) - 0.5;
    y = rowMap - mod(gridNum, rowMap) + 0.5;
    if y == rowMap + 0.5
        y = 0.5;
    end
end

