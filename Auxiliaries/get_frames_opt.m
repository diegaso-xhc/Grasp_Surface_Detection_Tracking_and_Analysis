function get_frames_opt(n_frames, mks, n_mks, cs_st, id_hand, data_name)
% This function takes the information of the hand markers during the motion
% study and creates a .mat file with 21x(3*n_frames) elements. Each row
% follows the order x, y, z (coodrinates) and every 3 columns the time
% frame increments.
n_col = 3*n_frames; % Total number of columns
frame = zeros(21, n_col);
for i = 1: n_mks
    ind = find_st_in_cell(cs_st.subjects{id_hand}.list_mks, mks{i}, 2); % Finding the corresponding marker order in our predefined markers list (which can change if needed)
    if i == 2        
        frame(i, :) = (frame(i - 1, :) + reshape(cs_st.subjects{id_hand}.markers{ind}.traj', 1, n_col)) / 2; % Finding the middle point of the wrist for hand frame tracking   
    else
        frame(i, :) = reshape(cs_st.subjects{id_hand}.markers{ind}.traj', 1, n_col); % Assignment of the remaining rows to the desired frame matrix     
    end    
end
save(strcat('./', data_name, '.mat'), 'frame'); % saves the whole hand markers frames as a single matrix, which is used by the python optimization script
end