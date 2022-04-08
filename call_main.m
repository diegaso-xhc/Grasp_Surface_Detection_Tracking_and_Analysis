function call_main()

%%%% Call dependencies
dependencies;
% load('MT_RH_HKRD_1230 009.mat') % Load the trial info we are trying to evaluate
load('MT_RH_AJZ8_1515 021.mat') % Load the trial info we are trying to evaluate
cs_st = st;
% cs_st1.plot_traj(); % Plots the trajectory on the VICON system
% name = 'Test_00006';
[n_hand, n_obj] = get_hand_obj_indices(cs_st); % Finds the right subject for the hand in each study (assumes one hand and one object)
name = 'tmp_del';
cs_st.save_data(n_obj, name); % Exports the information of the markers of the object into a .csv file
cs_st.subjects{n_hand}.build_results(); % Builds all required data for the hand, so that information such as reference axes, is available for use.
T = readtable(strcat(name, '.csv')); % Reads the previously saved information
T = T{:,:}; % From table to matrix. This matrix contains the positions of the markers along the whole trajectory.
ob = 11; % Object we have selected for the experiment
mark_ind = get_mks_ind(ob, markers_pos); % Find corrected marker assignment on the objects (this can be funed according to the user's needs
t_obj = ObjectInfo(triangulation(Y{ob, 1},  Y{ob, 2} - Y{ob, 2}(mark_ind(1), :))); % Creates a triangulation which is centered on the first point of the mark_ind vector
y_track = track_object(t_obj, mark_ind, T); % We change the bases from the object frame to a normal coordinate frame, so it can be plot with the hand later on
% plot_tracking_object(y_track); % Plots the tracking of the object. It can be used to assess whether or not the marker assignment of the object is done properly
n_frames = cs_st.n_smp; % Number of frames of the experiment
n_mks = length(mks); % Number of markers used for the human hand tracking
name_data_to_py = 'Tmp_process/data_to_opt';
get_frames_opt(n_frames, mks, n_mks, cs_st, n_hand, name_data_to_py); % Creates the required frame file to be used by the python optimization algorithm
betas = [0.4394211849484578, 1.5718488752572914, 0.4441326581811165, -3.184784177810678, -2.0533222423773667, -2.7747463926925033, 0.888224485138984, 1.7561999647492048, 4, 0.9774567444995015];
% betas = [0.15496452928836574, -1.258624864877278, 0.8793806490816679, -0.9772090579899397, 0.35669707616799057, -0.09034824091821289, 0.8389581199168163, -2.9711913696757626, 1.6525268795297678, -1.769129375386787];
fr_in = 400;
fr_end = 401;
[betas_str, fr_in_str, fr_end_str] = get_variable_str(betas, fr_in, fr_end);
vert_name = './Tmp_process/out_vert.mat';
face_name = './Tmp_process/out_face.mat';
system(strcat('python3.7 ./Fit_MANO/opt_MANO_MoCap.py --sequencedata', strcat(" ./", name_data_to_py, '.mat'),... % Calls an optimization algorithm in Python which uses the MANO hand model and runs the previously                                                                                                         
                                                    ' --vert_name', " ", vert_name,...                   % recorded marker sequence
                                                    ' --face_name', " ", face_name,...
                                                    ' --betas', " ", betas_str,...
                                                    ' --fr_in', " ", fr_in_str,...
                                                    ' --fr_end', " ", fr_end_str))
load(vert_name)
load(face_name)
vert_py = order_imported_matrix_n_row_cols(out_v);
faces_py = order_imported_matrix_n_row_cols(out_f);
th = 3; % Threshold for the distance between meshes which we have set to detect the contact surfaces
yf_cell = calculate_contacts(th, fr_in, Y, ob, y_track(fr_in: fr_end), vert_py, faces_py);
h = plot_results(vert_py, faces_py, y_track(fr_in: fr_end), yf_cell, fr_in);
disp('Final!')

end