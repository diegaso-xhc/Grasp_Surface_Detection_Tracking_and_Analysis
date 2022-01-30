% Developed by Diego Hidalgo C.

function [traj, ang]  = track_seg(st, sub, seg, id)
% This function returns the position of the markers involved in a desired
% part of the hand.
% seg is the segment of the right hand we are interested in
% typ is the type of element the segment represents, i.e. finger or set of markers
% st is the study of interest
n_mks = length(seg); % Number of markets on the segment
traj = {};
ang = {};

if nargin == 4
    if strcmp(id, 'thumb')
        id = "RightThumb";
        out = [strcat(id, "J1ProjAngles"), strcat(id, "J1AbsAngles"), strcat(id, "J2AbsAngles"), strcat(id, "J3AbsAngles")]; % Output variables
    elseif strcmp(id, 'index')
        id = "RightIndexFinger";
        out = [strcat(id, "J1ProjAngles"), strcat(id, "J1AbsAngles"), strcat(id, "J2AbsAngles"), strcat(id, "J3AbsAngles")]; % Output variables
    elseif strcmp(id, 'third')
        id = "RightThirdFinger";
        out = [strcat(id, "J1ProjAngles"), strcat(id, "J1AbsAngles"), strcat(id, "J2AbsAngles"), strcat(id, "J3AbsAngles")]; % Output variables
    elseif strcmp(id, 'ring')
        id = "RightRingFinger";
        out = [strcat(id, "J1ProjAngles"), strcat(id, "J1AbsAngles"), strcat(id, "J2AbsAngles"), strcat(id, "J3AbsAngles")]; % Output variables
    elseif strcmp(id, 'pinkie')
        id = "RightPinkie";
        out = [strcat(id, "J1ProjAngles"), strcat(id, "J1AbsAngles"), strcat(id, "J2AbsAngles"), strcat(id, "J3AbsAngles")]; % Output variables
    elseif strcmp(id, 'mk')
        out = [];
    elseif strcmp(id, 'out')
        n_mks = 0;
        out = seg;
    end    
    n_outs = length(out); % Number of output variables on the segment
    for i = 1: n_mks
        ind = find_st_in_cell(st.subjects{sub}.list_mks, seg(i), 2); % Index of the marker of the segment
        traj{i} = st.subjects{sub}.markers{ind}.traj; % Storage of trajectories of each marker
    end
    
    for i = 1: n_outs
        ind = find_st_in_cell(st.subjects{sub}.list_outs, out(i), 2); % Index of the output of the segment
        ang{i} = st.subjects{sub}.out_val{ind}.data; % Storage of the angle values of each marker
    end
end

end