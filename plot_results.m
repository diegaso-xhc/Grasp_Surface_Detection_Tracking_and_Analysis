function h = plot_results(vert_py, obj_track, y_cs, fr_i)
% This function plots the recorded contact surface interaction, including
% the contact surfaces. Each frame and contact surface can be individually
% accessed via the frames parameters fr_i and fr_end.

% v are the resulting vertices of the hand model during optimization
% obj_track contains the object meshes in all frames
% y_cs contains all of the contact surfaces across all frames
% fr_i is the initial frame, which concerns this plot. The final frame is
% embedded in the length of the other inputs

figure;
pl1 = plot3(NaN,NaN,NaN, '.', 'Color', [201, 151, 137]/255, 'MarkerSize', 10); % Plots the vertices of the hand meshes
hold on
pl2 = plot3(NaN,NaN,NaN, '.', 'MarkerSize', 15, 'Color', [0.32, 0.64, 0.74]); % Plots the object's trajectory
pl3 = plot3(NaN,NaN,NaN,'.', 'Color', [255, 0, 0]/255, 'MarkerSize',20); % Plots the contact surfaces

set(gcf, 'Position',  [10, 10, 1300, 1000])
set(gca,'XColor', 'none','YColor','none','ZColor','none')
set(gca,'color','none');
axis('equal')
pbaspect([1 1 1])
xlim([-300 600])
ylim([-200 1200])
zlim([-50 400])
xlabel('X')
ylabel('Y')
zlabel('Z')
view(-50,10)
grid off
set(gca,'XColor', 'none','YColor','none','ZColor','none')
set(gca,'color','none')

for i = 1: length(vert_py)
    i
    set(pl1,'XData',vert_py{i}(:,1),'YData',vert_py{i}(:,2), 'ZData', vert_py{i}(:,3)); % Hand Plot
    hold on    
    set(pl2,'XData',obj_track{i}(:,1),'YData',obj_track{i}(:,2), 'ZData', obj_track{i}(:,3)); % Object Plot
    num_CS = length(y_cs{i}{1}{1}); % Number of identified contact surfaces
    tmp_p = [];
    for j = 1: num_CS
       tmp_p = [tmp_p; y_cs{i}{1}{1}{j}.p]; % Collecting all of the contact points in a single nx3 array        
    end
    try 
        set(pl3,'XData',tmp_p(:, 1),'YData',tmp_p(:, 2), 'ZData', tmp_p(:, 3));
    catch
        disp(['No contacts detected on this frame: ', num2str(fr_i + i - 1)]) % set(pl3,'XData',0,'YData',0, 'ZData',0); % Whenever no contacts where detected
    end       
    title(sprintf('Frame N: %d', fr_i + i - 1))
    hold off
    pause(0.1)
end

h = gcf; % Returns the handle properties of the current figure
end