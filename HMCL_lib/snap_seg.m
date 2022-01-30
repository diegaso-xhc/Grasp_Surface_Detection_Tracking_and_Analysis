% Developed by Diego Hidalgo C.

function [traj, ang] = snap_seg(traj_in, ang_in, n)
% This function returns information on the trajectories and the angles of a
% given segment for a single specified sample (such as a snapshot of the
% trajectory)
n_mks = length(traj_in);
n_outs = length(ang_in);
traj = [];
ang = [];
for i = 1: n_mks
    if size(traj_in{i}, 1) == 3
        if i == 1
            traj = traj_in{i}(:, n)';
        else
            traj = [traj; traj_in{i}(:, n)']; % Creating a single matrix with the corresponding values of the snapshot of the trajectory
        end        
    else 
        if i == 1
            traj = traj_in{i}(n, :);
        else
            traj = [traj; traj_in{i}(n, :)]; % Creating a single matrix with the corresponding values of the snapshot of the trajectory
        end        
    end    
end
for i = 1: n_outs
    if size(ang_in{i}, 1) == 3
        if i == 1
            ang = ang_in{i}(:, n)';
        else
            ang = [ang; ang_in{i}(:, n)']; % Creating a single matrix with the corresponding values of the snapshot of the angles
        end
    else
        if i == 1
            ang = ang_in{i}(n, :);
        else
            ang = [ang; ang_in{i}(n, :)]; % Creating a single matrix with the corresponding values of the snapshot of the angöes
        end
    end
end

end