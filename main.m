clear all
close all
clc

%%%% Call dependencies
dependencies;
load('MT_RH_HKRD_1230 009.mat') % Load the trial info we are trying to evaluate
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
name_data_to_py = 'data_to_opt';
get_frames_opt(n_frames, mks, n_mks, cs_st, n_hand, name_data_to_py); % Creates the required frame file to be used by the python optimization algorithm
betas = [0.4394211849484578, 1.5718488752572914, 0.4441326581811165, -3.184784177810678, -2.0533222423773667, -2.7747463926925033, 0.888224485138984, 1.7561999647492048, 4, 0.9774567444995015];
% betas = [0.4394211849484578, 1.5718488752572914, 0.4441326581811165, -3.184784177810678, -2.0533222423773667, -2.7747463926925033, 0.888224485138984, 1.7561999647492048, 4, 0.9774567444995015]*-4;
fr_in = 20;
fr_end = 1000;
[betas_str, fr_in_str, fr_end_str] = get_variable_str(betas, fr_in, fr_end);
vert_name = './out_vert.mat';
face_name = './out_face.mat';
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
th = 10; % Threshold for the distance between meshes which we have set to detect the contact surfaces
yf_cell = calculate_contacts(th, fr_in, Y, ob, y_track(fr_in: fr_end), vert_py, faces_py);
h = plot_results(vert_py, faces_py, y_track(fr_in: fr_end), yf_cell, fr_in);
disp('Final!')

             

%%
% load('Cylinder_wb_frame650.mat')
% 
% 
% object = {};
% hand = {};
% th = 12;
% yf_cell_650_w = {};
% y_cell_650_w = {};
% 
% object{1} = triangulation(Y{ob, 1}, y_track{650});
% hand{1} = triangulation(double(faces_650), vert_650);
% [yf y] = getContactSurfaces(object, hand, th, 'near');
% yf_cell_650_w{1} = yf;
% y_cell_650_w{1} = y;
% 
% load('Cylinder_wob_frame650.mat')
% 
% object = {};
% hand = {};
% th = 12;
% yf_cell_650_wo = {};
% y_cell_650_wo = {};
% 
% object{1} = triangulation(Y{ob, 1}, y_track{650});
% hand{1} = triangulation(double(faces_frame650_wob), verts_frame650_wob);
% [yf y] = getContactSurfaces(object, hand, th, 'near');
% yf_cell_650_wo{1} = yf;
% y_cell_650_wo{1} = y;
% 
% 
% 
% 
% 
% figure;
% % h1Plot = plot3(NaN,NaN,NaN, '.', 'Color', [0.7290 0.6940 0.150, 0.1], 'MarkerSize', 10); % Hand plot
% h1Plot = plot3(NaN,NaN,NaN, '.', 'Color', [201, 151, 137]/255, 'MarkerSize', 10); % Hand plot
% 
% % h1Plot = scatter3(NaN, NaN, NaN, 'MarkerEdgeAlpha', 0.2)
% 
% hold on
% h2Plot = plot3(NaN,NaN,NaN, '.', 'MarkerSize', 15, 'Color', [0.32, 0.64, 0.74]); % Hand plot
% 
% 
% h3Plot = plot3(NaN,NaN,NaN,'.k','MarkerSize',40); % Hand plot
% h4Plot = plot3(NaN,NaN,NaN, '.', 'Color', [100, 151, 137]/255, 'MarkerSize', 10); % Hand plot
% h5Plot = plot3(NaN,NaN,NaN,'.', 'Color', [255, 0, 0]/255, 'MarkerSize',15); % Hand plot
% h6Plot = plot3(NaN,NaN,NaN, '.', 'Color', [0.0, 0.81, 0.3, 0.1], 'MarkerSize',15); % Hand plot
% 
% set(gcf, 'Position',  [10, 10, 1300, 1000])
% % h1Plot.Color(4) = 0.1;
% 
% axis('equal')
% pbaspect([1 1 1])
% xlim([200 600])
% ylim([800 1200])
% zlim([-50 400])
% xlabel('X')
% ylabel('Y')
% zlabel('Z')
% view(45,15)
% grid off
% set(gca,'XColor', 'none','YColor','none','ZColor','none')
% set(gca,'color','none')
% cnt = 0;
% for i = 650: 650
%     cnt = cnt + 1;
% %     set(h1Plot,'XData',vert_650(:,1),'YData',vert_650(:,2), 'ZData', vert_650(:,3)); % Hand Plot
%     hold on    
%     set(h2Plot,'XData',y_track{i}(:,1),'YData',y_track{i}(:,2), 'ZData', y_track{i}(:,3)); % Object Plot
%     num_CS = length(yf_cell_650_w{cnt}{1}{1}); % Number of identified contact surfaces
%     tmp_points = [];
%     for j = 1: num_CS
%        tmp_points = [tmp_points; yf_cell_650_w{cnt}{1}{1}{j}.p]; % Collecting all of the contact points in a single nx3 array        
%     end
%     try 
%         set(h5Plot,'XData',tmp_points(:, 1),'YData',tmp_points(:, 2), 'ZData', tmp_points(:, 3));
%     catch
%         set(h5Plot,'XData',0,'YData',0, 'ZData',0);
%     end   
%     
% %     set(h4Plot,'XData',verts_frame650_wob(:,1),'YData',verts_frame650_wob(:,2), 'ZData', verts_frame650_wob(:,3)); % Hand Plot
%     num_CS = length(yf_cell_650_wo{cnt}{1}{1}); % Number of identified contact surfaces
%     tmp_points = [];
%     for j = 1: num_CS
%        tmp_points = [tmp_points; yf_cell_650_wo{cnt}{1}{1}{j}.p]; % Collecting all of the contact points in a single nx3 array        
%     end
%     try 
%         set(h6Plot,'XData',tmp_points(:, 1),'YData',tmp_points(:, 2), 'ZData', tmp_points(:, 3));
%     catch
%         set(h6Plot,'XData',0,'YData',0, 'ZData',0);
%     end 
%     
%     title(sprintf('Frame N: %d',i))
%     hold off
%     pause(0.002)
% end

%%%%%%%%%%%%%%%%%%%%%% Additional Information %%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% ob = 2; % Cylinder with the positions after noticing I forgot this on
%             %%% experiment
% mark_ind(1) = markers_pos{ob}(1);
% mark_ind(2) = markers_pos{ob}(2);
% mark_ind(3) = markers_pos{ob}(4);
% mark_ind(4) = markers_pos{ob}(3);
% 
% % ob = 11; % Object No.11 is for the wine glass
% % mark_ind(1) = markers_pos{ob}(4);
% % mark_ind(2) = markers_pos{ob}(3);
% % mark_ind(3) = markers_pos{ob}(2);
% % mark_ind(4) = markers_pos{ob}(1);

% save('/home/diego/Desktop/Diego_MSRM/Research/Experiments/Framework_Contact_Surface_detection/Idyosincratic_Hand_Model/Trials/test_complete_data_V2.mat', 'frame')

% system(strcat('python3.7 /home/diego/Desktop/Diego_MSRM/Research/Experiments/Framework_Contact_Surface_detection/fitting_MANO/grasping_TUM/MANO_MATLAB_fit.py --sequencedata',...
%     ' /home/diego/Desktop/Diego_MSRM/Research/Experiments/Framework_Contact_Surface_detection/Idyosincratic_Hand_Model/Trials/', ...
%     'test_complete_data_V2.mat'))

% load('verts_opt_V2_nob.mat')
% load('faces_opt_V2_nob.mat')
% 
% vert_nob = order_imported_matrix_n_row_cols(output_vertices);
% faces_nob = order_imported_matrix_n_row_cols(output_faces);
% 
% load('verts_opt_V2.mat')
% load('faces_opt_V2.mat')
% 
% vert = order_imported_matrix_n_row_cols(output_vertices);
% faces = order_imported_matrix_n_row_cols(output_faces);
% %n_frames
% ind = 209;
% init_fr = 1;
% end_fr = 1;
% 
% for i = init_fr: end_fr
%     cnt = cnt + 1;  
%     object{1} = triangulation(Y{ob, 1}, y_track{i});
%     hand{1} = triangulation(double(faces{i} + 1), vert{i});
%     [yf y] = getContactSurfaces(object, hand, th, 'near');
%     yf_cell{cnt} = yf;
%     y_cell{cnt} = y;
%     cnt
% end
% 
% yf_cell_nob = {};
% y_cell_no = {};
% cnt = 0;
% for i = init_fr: end_fr
%     cnt = cnt + 1;  
%     object{1} = triangulation(Y{ob, 1}, y_track{i});
%     hand{1} = triangulation(double(faces_nob{i} + 1), vert_nob{i});
%     [yf y] = getContactSurfaces(object, hand, th, 'near');
%     yf_cell_nob{cnt} = yf;
%     y_cell_no{cnt} = y;
%     cnt
% end


% save(strcat('Points_Hand_test_cup_fit', num2str(test), '.mat'), 'P')
% save(strcat('../Contact_surfaces_1400015_nob', '.mat'), 'yf_cell', '-v7.3')

% save(strcat('Points_Hand_test_cup_fit', num2str(test), '.mat'), 'P')
% save(strcat('../Contact_surfaces_cup_fit', num2str(test), '.mat'), 'yf_cell', '-v7.3')
 
% load('Points_Hand_test_cup_fit22.mat')
% load('Contact_surfaces_cup_fit22.mat')

% load('Points_Hand_test20.mat')
% load('Contact_surfaces20.mat')

% load(strcat('../Contact_surfaces_1400015_nob', '.mat'))
% yf_cell_nob = yf_cell;
% load(strcat('../Contact_surfaces_1400015', '.mat'))

% cnt2 = 0;
% % for i = 1: n_frames
% for i = 1: n_frames
%     cnt2 = cnt2 + 1;    
% %     P{i} = P{i} - (P{i}(209,:) - cs_st.subjects{2}.ax(1:3, i)');
%     set(h1Plot,'XData',vert{cnt2}(:,1),'YData',vert{cnt2}(:,2), 'ZData', vert{cnt2}(:,3));
%     hold on
%     set(h2Plot,'XData',y_track{i}(:,1),'YData',y_track{i}(:,2), 'ZData', y_track{i}(:,3));
% %     set(h3Plot,'XData', cs_st.subjects{n_hand}.ax(1, i), 'YData', cs_st.subjects{n_hand}.ax(2, i), 'ZData', cs_st.subjects{n_hand}.ax(3, i));
% %     ax_o = cs_st.subjects{n_hand}.ax(1: 3, i);
% %     ax_x = cs_st.subjects{n_hand}.ax(4: 6, i)*80;
% %     ax_y = cs_st.subjects{n_hand}.ax(7: 9, i)*80;
% %     ax_z = cs_st.subjects{n_hand}.ax(10: 12, i)*80;
% %     set(h4Plot_ax, 'XData', [ax_o(1) ax_o(1) ax_o(1)], 'YData', [ax_o(2) ax_o(2) ax_o(2)], 'ZData', [ax_o(3) ax_o(3) ax_o(3)],...
% %         'UData', [ax_x(1), ax_y(1), ax_z(1)], 'VData', [ax_x(2), ax_y(2), ax_z(2)], 'WData', [ax_x(3), ax_y(3), ax_z(3)]);   
%     hold on
% %     plotManipulation(object, y, hand, yf)
% %     plotContactRegions_v2(yf_cell{i}{1}, [200 20 60]/255)    
%     
%     num_CS = length(yf_cell{cnt2}{1}{1}); % Number of identified contact surfaces
%     tmp_points = [];
%     for j = 1: num_CS
%        tmp_points = [tmp_points; yf_cell{cnt2}{1}{1}{j}.p]; % Collecting all of the contact points in a single nx3 array        
%     end
% %     length(tmp_points)
%     try 
% %         set(h5Plot,'XData',yf_cell{cnt2}{1}{1}{1}.p(:,1),'YData',yf_cell{cnt2}{1}{1}{1}.p(:,2), 'ZData', yf_cell{cnt2}{1}{1}{1}.p(:,3));
%         set(h5Plot,'XData',tmp_points(:, 1),'YData',tmp_points(:, 2), 'ZData', tmp_points(:, 3));
%     catch
%         set(h5Plot,'XData',0,'YData',0, 'ZData',0);
%     end
%     
%     hold off
%     pause(0.002)
% end

%% Plot results again

% figure;
% % h1Plot = plot3(NaN,NaN,NaN, '.', 'Color', [0.7290 0.6940 0.150, 0.1], 'MarkerSize', 10); % Hand plot
% h1Plot = plot3(NaN,NaN,NaN, '.', 'Color', [201, 151, 137]/255, 'MarkerSize', 10); % Hand plot
% 
% % h1Plot = scatter3(NaN, NaN, NaN, 'MarkerEdgeAlpha', 0.2)
% 
% hold on
% h2Plot = plot3(NaN,NaN,NaN, '.', 'MarkerSize', 15, 'Color', [0.32, 0.64, 0.74]); % Hand plot
% 
% 
% h3Plot = plot3(NaN,NaN,NaN,'.k','MarkerSize',40); % Hand plot
% h4Plot = plot3(NaN,NaN,NaN, '.', 'Color', [100, 151, 137]/255, 'MarkerSize', 10); % Hand plot
% h5Plot = plot3(NaN,NaN,NaN,'.', 'Color', [255, 0, 0]/255, 'MarkerSize',20); % Hand plot
% h6Plot = plot3(NaN,NaN,NaN,'.', 'Color', [0, 255, 0]/255, 'MarkerSize',15); % Hand plot
% 
% set(gcf, 'Position',  [10, 10, 1300, 1000])
% set(gca,'XColor', 'none','YColor','none','ZColor','none')
% set(gca,'color','none');
% % h1Plot.Color(4) = 0.1;
% 
% axis('equal')
% pbaspect([1 1 1])
% xlim([200 600])
% ylim([800 1200])
% zlim([-50 400])
% xlabel('X')
% ylabel('Y')
% zlabel('Z')
% view(-50,10)
% grid off
% set(gca,'XColor', 'none','YColor','none','ZColor','none')
% set(gca,'color','none')

% for i = 1: 1
%     set(h1Plot,'XData',vert{i}(:,1),'YData',vert{i}(:,2), 'ZData', vert{i}(:,3)); % Hand Plot
%     hold on    
%     set(h2Plot,'XData',y_track{i}(:,1),'YData',y_track{i}(:,2), 'ZData', y_track{i}(:,3)); % Object Plot
%     num_CS = length(yf_cell{i}{1}{1}); % Number of identified contact surfaces
%     tmp_points = [];
%     for j = 1: num_CS
%        tmp_points = [tmp_points; yf_cell{i}{1}{1}{j}.p]; % Collecting all of the contact points in a single nx3 array        
%     end
%     try 
%         set(h5Plot,'XData',tmp_points(:, 1),'YData',tmp_points(:, 2), 'ZData', tmp_points(:, 3));
%     catch
%         set(h5Plot,'XData',0,'YData',0, 'ZData',0);
%     end
%     
%     % This is without betas
% %     set(h4Plot,'XData',vert_nob{i}(:,1),'YData',vert_nob{i}(:,2), 'ZData', vert_nob{i}(:,3)); % Hand Plot
%     num_CS = length(yf_cell_nob{i}{1}{1}); % Number of identified contact surfaces
%     tmp_points_2 = [];
%     for j = 1: num_CS
%        tmp_points_2 = [tmp_points_2; yf_cell_nob{i}{1}{1}{j}.p]; % Collecting all of the contact points in a single nx3 array        
%     end
%     try 
% %         set(h6Plot,'XData',tmp_points_2(:, 1),'YData',tmp_points_2(:, 2), 'ZData', tmp_points_2(:, 3));
%     catch
% %         set(h6Plot,'XData',0,'YData',0, 'ZData',0);
%     end
%     %%%%%%%%
%     
%     
%     title(sprintf('Frame N: %d',i))
%     hold off
%     pause(0.002)
% end
% face_exp = faces{650};
% vert_exp = vert{650};
% save('data_mesh_coars.mat', 'face_exp', 'vert_exp')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



