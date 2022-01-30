clear

vicon = ViconNexus(); % Create an object of the ViconNexus class
subjects = vicon.GetSubjectNames; % Get the names of the objects being tracked
[path, name] = vicon.GetTrialName();
markers = vicon.GetMarkerNames(subjects{1}); % Get the markers name of subject 1
[trajX, trajY, trajZ, trajExists] = vicon.GetTrajectory(subjects{1}, markers{1});
traj = [trajX' trajY' trajZ'];

angle1 = vicon.GetModelOutput(subjects{1}, 'RightIndexFingerJ1AbsAngles');
angle2 = vicon.GetModelOutput(subjects{1}, 'RightIndexFingerJ1ProjAngles');
% angle3 = vicon.GetModelOutput(subjects{1}, 'RightIndexFingerJ2AbsAngles');

figure(3);
subplot(2, 1, 1)
plot(angle1(1,:), 'r')

figure(1);
for i = 1: 3
    subplot(3, 1, i)
    plot(traj(:, i))    
end
hold off
pause(1);
figure(2);
l = length(trajX);
for i = 1: l
   pause(0.001);
   plot3(traj(i, 1), traj(i, 2), traj(i, 3), '*r'); 
   hold on   
   if i == 1
       axis('equal')
       pbaspect([1 1 1])
       xlim([0 800])
       ylim([0 800])
       zlim([0 800])
       xlabel('X')
       ylabel('Y')
       zlabel('Z')
       grid on
   end
end


