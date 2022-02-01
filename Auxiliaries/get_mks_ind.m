function mark_ind = get_mks_ind(ob, markers_pos)
% This function corrects the markers indices assignment if the order of the
% markers is different with respect to the ones recorded on the VICON
% motion tracking system.
mark_ind = 0; % Correction of the points
if ob == 2
    mark_ind(1) = markers_pos{ob}(1);
    mark_ind(2) = markers_pos{ob}(2);
    mark_ind(3) = markers_pos{ob}(4);
    mark_ind(4) = markers_pos{ob}(3);
elseif ob == 11    
    mark_ind(1) = markers_pos{ob}(4);
    mark_ind(2) = markers_pos{ob}(3);
    mark_ind(3) = markers_pos{ob}(2);
    mark_ind(4) = markers_pos{ob}(1);
else
    mark_ind = markers_pos{ob};
end
end