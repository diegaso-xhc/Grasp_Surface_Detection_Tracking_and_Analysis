function [n_hand, n_obj] = get_hand_obj_indices(cs_st)
% This function takes as an input a VICON recording session object (see
% library of human motor control lab) and returns the indices of the
% subjects corresponding to the hand and the object. This assumes that the
% manipulation interaction is done using only one object.

n_subjects = length(cs_st.subjects);
for i = 1: n_subjects
    if strcmp(cs_st.subjects{i}.id_sub(1:2),'RH')
        n_hand = i; % Index of the hand within the VICON recording session
    end
end
if n_hand == 1
    n_obj = 2;
else
    n_obj = 1; % Index of the object within the VICON recording session
end
end