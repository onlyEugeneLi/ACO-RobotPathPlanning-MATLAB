function showPath(map, size, path, gen, ant)
figure(1);
for i = 1: size*size
    if map(i) == 1
        [x_p, y_p] = ConvertXY(i, size);
        x1 = x_p - 0.5; y1 = y_p + 0.5;
        x4 = x_p - 0.5; y4 = y_p - 0.5;
        x2 = x_p + 0.5; y2 = y_p + 0.5;
        x3 = x_p + 0.5; y3 = y_p - 0.5;
        fill([x1, x2, x3, x4], [y1, y2, y3, y4], [0.2 0.2 0.2]);
        hold on;
    else
        [x_p, y_p] = ConvertXY(i, size);
        x1 = x_p - 0.5; y1 = y_p + 0.5;
        x4 = x_p - 0.5; y4 = y_p - 0.5;
        x2 = x_p + 0.5; y2 = y_p + 0.5;
        x3 = x_p + 0.5; y3 = y_p - 0.5;
        fill([x1, x2, x3, x4], [y1, y2, y3, y4], 'w');
        hold on;
    end
end
hold on;
title('Map');
xlabel('x-axis'); 
ylabel('y-axis');
pathRecord = path{gen, ant};
ctr = length(pathRecord);
robot_x = zeros(ctr, 1);
robot_y = zeros(ctr, 1);
for j = 1: ctr
    [robot_x(j), robot_y(j)] = ConvertXY(pathRecord(j), size);
end
plot(robot_x, robot_y);
end

