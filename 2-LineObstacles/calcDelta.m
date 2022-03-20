function D = calcDelta(arr)
row = size(arr, 1);         % the number of rows of the array 
column = size(arr, 2);
D = zeros(row*column);     % initialise the delta_(r,s) matrix
for i = 1: row*column
    if arr(i) == 0
       for j = 1: row*column
          if arr(j) == 0 && (abs(i - j) == 11 || abs(i - j) == 10 || abs(i - j) == 9 || abs(i - j) == 1)
              [x1, y1] = ConvertXY(j, row);
              [x2, y2] = ConvertXY(i, row);
              D(i, j) = sqrt((x1 - x2)^2 + (y1 - y2)^2);
              D(j, i) = sqrt((x1 - x2)^2 + (y1 - y2)^2);
          end
       end
    end
end

end

