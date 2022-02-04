function h = plot_results(vert_py, faces_py, obj_track, y_cs, fr_i, options)
% This function plots the recorded contact surface interaction, including
% the contact surfaces. Each frame and contact surface can be individually
% accessed via the frames parameters fr_i and fr_end.

% v are the resulting vertices of the hand model during optimization
% obj_track contains the object meshes in all frames
% y_cs contains all of the contact surfaces across all frames
% fr_i is the initial frame, which concerns this plot. The final frame is
% embedded in the length of the other inputs
% options is a boolean vector that says what to plot [hand, hand_mesh, object, contact_surface]

figure;
pl1 = plot3(NaN,NaN,NaN, '.', 'Color', [0, 0, 255]/255, 'MarkerSize', 5); % Plots the vertices of the hand meshes
hold on
pl2 = plot3(NaN,NaN,NaN, '.', 'MarkerSize', 1, 'Color', [0.32, 0.64, 0.74]); % Plots the object's trajectory
pl3 = plot3(NaN,NaN,NaN,'.', 'Color', [255, 0, 0]/255, 'MarkerSize',20); % Plots the contact surfaces
set(gcf, 'Position',  [10, 10, 1300, 1000])
set(gca,'XColor', 'none','YColor','none','ZColor','none')
set(gca,'color','none');
axis('equal')
pbaspect([1 1 1])
xlim([0 600])
ylim([600 1100])
zlim([-50 400])
xlabel('X')
ylabel('Y')
zlabel('Z')
view(-80,15)
grid off
set(gca,'XColor', 'none','YColor','none','ZColor','none')
set(gca,'color','none')

if nargin == 6 % In case there is an options plot passed as an argument
    if options(2) == 1
        pl1_mesh = handle(trimesh(triangulation(double(faces_py{1} + 1), vert_py{1}))); % Plot the hand as a mesh
        pl1_mesh.EdgeColor = [201, 151, 137]/255;
        pl1_mesh.FaceAlpha = 0.4;
        pl1_mesh.EdgeAlpha = 0.5;
    end    
    for i = 1: length(vert_py)
        if options(1) == 1, set(pl1,'XData',vert_py{i}(:,1),'YData',vert_py{i}(:,2), 'ZData', vert_py{i}(:,3)); end % Hand Plot
        hold on
        if options(2) == 1, set(pl1_mesh, 'vertices', vert_py{i}), end % Plot the hand mesh
        if options(3) == 1, set(pl2,'XData',obj_track{i}(:,1),'YData',obj_track{i}(:,2), 'ZData', obj_track{i}(:,3)); end % Object Plot
        if options(4) == 1
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
        end
        title(sprintf('Frame N: %d', fr_i + i - 1))
        hold off
        pause(0.01)
    end
else % If a normal plot without the argument options is being requested
    pl1_mesh = handle(trimesh(triangulation(double(faces_py{1} + 1), vert_py{1}))); % Plot the hand as a mesh
    pl1_mesh.EdgeColor = [201, 151, 137]/255;
    pl1_mesh.FaceAlpha = 0.4;
    pl1_mesh.EdgeAlpha = 0.5;
    for i = 1: length(vert_py)
        set(pl1,'XData',vert_py{i}(:,1),'YData',vert_py{i}(:,2), 'ZData', vert_py{i}(:,3)); % Hand Plot
        hold on
        set(pl1_mesh, 'vertices', vert_py{i}); % Plot the hand mesh
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
        pause(0.01)
    end
end
h = gcf; % Returns the handle properties of the current figure
end