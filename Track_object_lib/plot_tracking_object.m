function plot_tracking_object(y)
nf = length(y);
figure;
h1Plot = plot3(NaN,NaN,NaN,'.r'); % Hand plot
set(gcf, 'Position',  [10, 10, 1300, 1000])
h1Plot.Color(4) = 0.1;
hold on
axis('equal')
pbaspect([1 1 1])
xlim([-1000 2000])
ylim([-1000 2000])
zlim([-50 1000])
xlabel('X')
ylabel('Y')
zlabel('Z')
str = strcat('Trial:', '  ');
title(str)
view(-80,15)
grid on
for i = 1: nf    
    X = y{i}(:, 1);
    Y = y{i}(:, 2);
    Z = y{i}(:, 3);
    set(h1Plot,'XData',X,'YData',Y, 'ZData', Z);    
    hold on
    pause(0.002)    
end
end