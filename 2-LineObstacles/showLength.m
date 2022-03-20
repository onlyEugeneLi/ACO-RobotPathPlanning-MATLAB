function showLength(arr)
figure(2)

row = size(arr, 1);
column = size(arr, 2);
minLength = zeros(row, 1);
for i = 1: row
    arrRows = arr(i, :);
    index = arrRows ~= 0;
    arrRows = arrRows(index);
    minLength(i) = min(arrRows);
end
plot(minLength);
hold on
grid on
title('Path Length Changes During Iterations');
xlabel('Iteration');
ylabel('Minimum Path Length');
end

