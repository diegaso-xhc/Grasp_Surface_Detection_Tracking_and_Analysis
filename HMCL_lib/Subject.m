% Developed by Diego Hidalgo C.

classdef Subject < handle
   properties
      markers % These are the markers belonging to this subject      
      id_sub % This is the name of the subject   
      n_mk % Number of markers on this subject
      traj_mat % This is a matrix of (n x 3*n_mk)
      out_names % These are the outputs names of the model
      out_val % Values of the outputs of the model
      ax % These are the axes of the subject
      n_smp % Number of sumples for this subject
      list_mks % List of the markers on the subject
      list_outs % List of the outputs on the subject
   end   
   methods
      function obj = Subject(markers, id_sub)
         global vicon
         obj.markers = markers;
         obj.id_sub = id_sub;         
         obj.n_mk = length(obj.markers);
         obj.traj_mat = [];
         for i = 1: obj.n_mk             
            obj.traj_mat = [obj.traj_mat, obj.markers{i}.traj]; % Add each marker's trajectory to this matrix
         end         
         obj.out_names = vicon.GetModelOutputNames(obj.id_sub); % Names of the outputs for the current model
         obj.out_val = {};
         for i = 1: length(obj.out_names)
             [obj.out_val{i}.data, obj.out_val{i}.exists] = vicon.GetModelOutput(obj.id_sub, obj.out_names{i}); % Get the values and a the exists boolean for each model outpu
         end    
         obj.ax = NaN; % Not assigned unless, we need this information (to optimize computing speed)
         obj.n_smp = size(obj.markers{1}.traj, 1); % Number of samples on this subject
         obj.list_mks = NaN; % Not assigned unless, we need this information (to optimize computing speed)
         obj.list_outs = NaN; % Not assigned unless, we need this information (to optimize computing speed)
      end
      function obj = build_results(obj)
          try
              % We try to builde the results for the human hand, but if the
              % subject is not the human hand, we just get the markers list
              ind_o = find_st_in_cell(obj.out_names, 'ORIGINRHand1');
              ind_x = find_st_in_cell(obj.out_names, 'XAXISRHand1');
              ind_y = find_st_in_cell(obj.out_names, 'YAXISRHand1');
              ind_z = find_st_in_cell(obj.out_names, 'ZAXISRHand1');
              o = obj.out_val{ind_o}.data;
              x = obj.out_val{ind_x}.data;
              y = obj.out_val{ind_y}.data;
              z = obj.out_val{ind_z}.data;
              x = x-o;
              y = y-o;
              z = z-o;
              obj.ax = zeros(12, obj.n_smp);
              for i = 1: obj.n_smp
                  x(:, i) = x(:, i)/norm(x(:, i));
                  y(:, i) = y(:, i)/norm(y(:, i));
                  z(:, i) = z(:, i)/norm(z(:, i));
              end
              obj.ax = [o;x;y;z]; % Comprise reference axes within a single matrix
              obj.list_mks = obj.get_mks_list(obj.markers); % List of the markers on the subject
              obj.list_outs = obj.get_var_list(obj.out_names); % LIst of the outputs on the subject, if any
              get_lists(obj);
          catch
              get_lists(obj);
          end
          
      end
      function obj = get_lists(obj)
         obj.list_mks = obj.get_mks_list(obj.markers); % List of the markers on the subject
         obj.list_outs = obj.get_var_list(obj.out_names); % LIst of the outputs on the subject, if any
      end
   end
   methods(Static)
      function y = get_var_list(out_names)
          % This function returns a list with the names of the variables
          % and their order. Sometimes the output variables are ordered
          % differently in the vicon software
          l = length(out_names);
          y = {};
          for i = 1: l             
             y{i, 1} = i;
             y{i, 2} = out_names{i};
          end          
      end 
      function y = get_mks_list(mks)
          % This function returns a list with the names of the markers
          % and their order. Sometimes the marker names are ordered
          % differently in the vicon software
          l = length(mks);
          y = {};
          for i = 1: l             
             y{i, 1} = i;
             y{i, 2} = mks{i}.id_mk;
          end          
      end 
   end
end