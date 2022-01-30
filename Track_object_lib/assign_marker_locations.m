%%%% This file generates the indices of the points where the markers are
%%%% located on the objects. This is merely an approximation and depends on
%%%% the resolution of the mesh. This was developed to overcome the fact
%%%% that there are no physical places for the markers on the objects. This
%%%% has to be corrected in the future.

clear all
close all
clc

load('Uniform_meshes.mat')
ob = 11;
m = [4 4 4 4 4 4 4 5 2 4 4 3]; % Number of markers per object
points = {}; % Variable to store the indices of the points where the markers are (approximation only)

for i = 1: 12
figure;
ob = i;
t = triangulation(Y{ob, 1}, Y{ob, 2});
h = trimesh(t);
h.EdgeColor = [0 0 0];
h.FaceAlpha = 1;
h.EdgeAlpha = 0.8;
axis('equal')
hold off
xlabel('X')
ylabel('Y')
zlabel('Z')    

o = mean(Y{ob, 2}(find(Y{ob, 2}(:, 3) < 5), :) ,1);
o(3) = min(Y{ob, 2}(:,3));
o = Y{ob, 2}(get_point(Y{ob, 2}, o), :);
hold on 

p = zeros(m(i),3);
pm = zeros(m(i),3);
po = o + [0 0 max(Y{ob, 2}(:,3))];

if i == 1
    % Object 1
    po = o + [0 0 max(Y{ob, 2}(:,3))];
    p(1,:) = po + [-1.48, -1.48, 0];
    p(2,:) = po + [-12.55, -24.00, 0];
    p(3,:) = po + [-15, +26.00, 0];
    p(4,:) = po + [-14.14, +31.87, -15.80];
    points{1} = get_point(Y{ob, 2}, p);
elseif i == 2
    % Object 2
    po = o + [0 0 max(Y{ob, 2}(:,3))];
    p(1,:) = o + [0 0 max(Y{ob, 2}(:,3))] + [0 -28.79 0];
    p(2,:) = po + [-28.7104 -2.1399 0];
    p(3,:) = p(1,:) + [-4.60 -3.53 -34.77];
    p(4,:) = po + [-po(1) + 1.7, 20, -12.12];
    % points{2} = [2047;2563;8478;4408];
    points{2} = get_point(Y{ob, 2}, p);
elseif i == 3
    % Object 3
    po = o + [0 0 max(Y{ob, 2}(:,3))];
    p(1,:) = po + [12.2-1.5, 12.5-1.5, 0];
    p(2,:) = po + [-12.5+1.5, -12.5+1.5, 0];
    p(3,:) = po + [12.5-2.12, -12.5+1.5, 0];
    p(4,:) = po + [-12.5+1.5, -12.5, -25+1.65];
    points{3} = get_point(Y{ob, 2}, p);
elseif i == 4
    % Object 4
    po = o + [0 0 max(Y{ob, 2}(:,3))];
    po = o + [0 0 0];
    p(1,:) = po + [0, -26, 16.53];
    p(2,:) = p(1,:) + [22.23, -13.64, 88.35-16.53];
    p(3,:) = p(1,:) + [-22.30, -13.64, 88.64-16.53];
    po = o + [0 0 max(Y{ob, 2}(:,3))];
    p(4,:) = po + [-4.57, 42.615, 0];
    points{4} = get_point(Y{ob, 2}, p);
elseif i == 5
    % Object 5
    tmp = Y{ob, 2}(find(Y{ob, 2}(:, 3) <0.001), :);
    po = [min(tmp(:,1)) min(tmp(:,2)) 0];
    po = Y{ob, 2}(get_point(Y{ob, 2}, po), :);
    p(1,:) = po + [1.0 14.62 47.91];
    p(2,:) = p(1,:) + [140.21-10.46 15.82-1.5 16.57];
    p(3,:) = [0 35.1 270.9];
    p(4,:) = p(3,:) + [73.95 -13.70 -47.40];
    points{5} = get_point(Y{ob, 2}, p);
elseif i == 6
    % Object 6
    tmp = Y{ob, 2}(find(Y{ob, 2}(:, 3) <0.001), :);
    po = [min(tmp(:,1)) min(tmp(:,2)) 0];
    po = Y{ob, 2}(get_point(Y{ob, 2}, po), :);
    p(1,:) = po + [2.50 16.62 47.91];
    p(2,:) = p(1,:) + [68.15 -2.09 178.0];
    p(3,:) = p(2,:) + [79.84 1.0 15.77];
    p(4,:) = p(1,:) + [185 8.2 15.89];
    points{6} = get_point(Y{ob, 2}, p);
elseif i == 7
    % Object 7
    po = o + [0 0 max(Y{ob, 2}(:,3))];
    p(1,:) = po;
    p(2,:) = po + [0.68 -46.18, 0];
    p(3,:) = po + [45.70, -0.81, 0];
    p(4,:) = po + [51, -3, -44.64];
    points{7} = get_point(Y{ob, 2}, p);
elseif i == 8
    % Object 8
    po = o + [0 0 0];
    p(1,:) = po + [34.46, 0, 16.82];
    p(2,:) = po + [34.46 0, 92.27];
    p(3,:) = p(2,:) + [-10.94, +23.90, 6.39];
    p(4,:) = p(2,:) + [-47.69, 24, 6.90];
    p(5,:) = p(2,:) + [-47.69, -24, 6.90];
    points{8} = get_point(Y{ob, 2}, p);
elseif i == 9
    % Object 9
    po = o + [0 0 max(Y{ob, 2}(:,3))];
    p(1,:) = o;
    p(2,:) = po;
    points{9} = get_point(Y{ob, 2}, p);
elseif i == 10
    % Object 10
    po = [0 0 0];
    p(1,:) = po + [0.7034 2.118 30];
    p(2,:) = po + [0.7034 119.3 30];
    p(3,:) = po + [203.3 119.3 30];
    p(4,:) = p(2,:) + [0, -2.03, -25.93];
    points{10} = get_point(Y{ob, 2}, p);
elseif i == 11
    % Object 11
    po = [0 0 0];
    p(1,:) = po + [32.74 23.5 7.39];
    p(2,:) = p(1,:) + [0 -15.16 152.97-7.39];
    p(3,:) = p(2,:) + [0 48.07 -2.80];
    p(4,:) = p(3,:) + [19.23, -11.03, 1.71];
    points{11} = get_point(Y{ob, 2}, p);
elseif i == 12
    % Object 12
    po = o + [0 0 max(Y{ob, 2}(:,3))];
    p(1,:) = po + [0 -9.47 0];
    p(2,:) = p(1,:) + [6.75 14.78 0];
    p(3,:) = p(1,:) + [-9.33 15.44 0];
    points{12} = get_point(Y{ob, 2}, p);
end

for j = 1: m(i)
    plot3(p(j,1), p(j,2), p(j,3), '*b')
end
pm = Y{ob, 2}(get_point(Y{ob, 2}, p), :);
for j = 1: m(i)
    plot3(pm(j,1), pm(j,2), pm(j,3), '*r')
end

hold off
% pause()
end

markers_pos = points;
save('markers_pos.mat', 'markers_pos');


