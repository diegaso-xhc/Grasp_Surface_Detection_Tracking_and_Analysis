% Developed by Diego Hidalgo C.

function [subjects, path, name, n_smp] = get_info_trial(t1, t2)
global vicon
if nargin == 0
    % Gather all of the information on the study   
    vicon = ViconNexus(); % Create an object of the ViconNexus class
    [subs, templates, active] = vicon.GetSubjectInfo(); % This function gets the subjects names, the type of element and a boolean showing which subject is active in the current trial
    tmp = find(active == 0);
    if ~isempty(tmp)
       for i = 1: length(tmp) 
          subs{tmp(i)} = []; % Assign an empty value to the inactive subjects on the trial
       end
    end    
    subs = subs(~cellfun('isempty',subs)); % Remove empty cell arrays (corresponding to inactive objects on the motion trial)    
    [path, name] = vicon.GetTrialName(); % Get the trial name
    ls = length(subs); % Number of subjects on the study
    markers = {{}}; % Cell containing all of the markers from every subject
    subjects = {}; % Cell containing all of the subjects from the trial
    for i = 1: ls
        ids_mk = vicon.GetMarkerNames(subs{i}); % Get the markers names of subject i
        lm = length(ids_mk);
        for j = 1: lm            
            [trajx, trajy, trajz, traj_exist] = vicon.GetTrajectory(subs{i}, ids_mk{j}); % Get the trajectories of each marker
            markers{i}{j} = Marker(trajx, trajy, trajz, traj_exist, ids_mk{j}, subs{i}); % Creat Marker objects for each one of the markers
            if i == 1 && j == 1
               n_smp = length(trajx); 
            end
        end
        subjects{i} = Subject(markers{i}, subs{i}); % Create subject objects for each subject
    end
elseif nargin == 2
    % Gather the information on the study only on the given time range
    vicon = ViconNexus(); % Create an object of the ViconNexus class
    [subs, templates, active] = vicon.GetSubjectInfo(); % This function gets the subjects names, the type of element and a boolean showing which subject is active in the current trial
    tmp = find(active == 0);
    if ~isempty(tmp)
       for i = 1: length(tmp) 
          subs{tmp(i)} = []; % Assign an empty value to the inactive subjects on the trial
       end
    end    
    subs = subs(~cellfun('isempty',subs)); % Remove empty cell arrays (corresponding to inactive objects on the motion trial)   
    [path, name] = vicon.GetTrialName(); % Get the trial name
    ls = length(subs); % Number of subjects on the study
    markers = {{}}; % Cell containing all of the markers from every subject
    subjects = {}; % Cell containing all of the subjects from the trial
    for i = 1: ls
        ids_mk = vicon.GetMarkerNames(subs{i}); % Get the markers names of subject i
        lm = length(ids_mk);
        for j = 1: lm
            [trajx, trajy, trajz, traj_exist] = vicon.GetTrajectory(subs{i}, ids_mk{j}); % Get the trajectories of each marker
            trajx = trajx(t1:t2);
            trajy = trajy(t1:t2);
            trajz = trajz(t1:t2);
            traj_exist = traj_exist(t1:t2);
            markers{i}{j} = Marker(trajx, trajy, trajz, traj_exist, ids_mk{j}, subs{i}); % Creat Marker objects for each one of the markers
            if i == 1 && j == 1
                n_smp = length(trajx);
            end
        end
        subjects{i} = Subject(markers{i}, subs{i}); % Create subject objects for each subject
    end
else 
    
    % This section will include gathering information from a specific trial
    % for now it is just a place holder
    subjects = 0;
    path = 0;
    name = 0;
end
end