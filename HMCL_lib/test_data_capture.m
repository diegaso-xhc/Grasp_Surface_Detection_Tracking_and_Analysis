% Developed by Diego Hidalgo C.

%% Initialize modules
% clc 
% clear all
% close all

%% Manipulating data

% st1 = Study(); % Gather the information and data from a trial 
% st1.plot_mk(1, 24, 0); % Plot the marker 24 trajectory
% st1.plot_traj(); % Plot the motion study of subject 1 and subject 2
st1.subjects{2}.build_results();
% st1.plot_traj_ax(2, 150);
%% Plot output angles

figure;
sub = 2;
n = 14;
subplot(3, 1, 1)
plot(st1.subjects{sub}.out_val{n}.data(1,:),'g')
subplot(3, 1, 2)
plot(st1.subjects{sub}.out_val{n}.data(2,:),'b')
subplot(3, 1, 3)
plot(st1.subjects{sub}.out_val{n}.data(3,:),'c')

%% Save study
save('Trial002_s2','st1')

