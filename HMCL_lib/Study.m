% Developed by Diego Hidalgo C.

classdef Study
    properties
        subjects % These are the subjects belonging to this study
        path % Path of the information
        name % Name of the trial for the study
        n_smp % Number of samples during the study
    end
    methods
        function obj = Study(t1, t2)
            % t1 and t2 are the times of interest of the trial
            if nargin == 0
                [subjects, path, name, n_smp] = get_info_trial();
            else
                [subjects, path, name, n_smp] = get_info_trial(t1, t2);
            end
            obj.subjects = subjects; % Subjects of the study
            obj.path = path; % Path of the file
            obj.name = name; % Name of the trial
            obj.n_smp = n_smp; % Number of samples
        end        
        function plot_mk(obj, sub, mk, hld)
            tmp = ['X', 'Y', 'Z'];
            for i = 1: 3
                subplot(3, 1, i)
                plot(obj.subjects{sub}.markers{mk}.traj(:, i), 'r')
                if hld == 1
                    hold on
                else
                    hold off
                end
                xlabel('Sample')
                ylabel(tmp(i))
                grid on
            end
        end
        function plot_traj(obj)            
            figure;
            h1Plot = plot3(NaN,NaN,NaN,'.r'); % Hand plot
            hold on
            h2Plot = plot3(NaN,NaN,NaN,'.b'); % Object plot
            axis('equal')
            pbaspect([1 1 1])            
            xlim([-400 1800])
            ylim([-200 1400])
            zlim([-700 1500])
            xlabel('X')
            ylabel('Y')
            zlabel('Z')
            str = strcat('Trial:', '  ', obj.name(end-2: end));
            title(str)
            grid on
            ls = length(obj.subjects); % Number of subjects
            for t = 1: obj.n_smp
                for i = 1: ls
                    X = obj.subjects{i}.traj_mat(t, 1:3:end)';
                    Y = obj.subjects{i}.traj_mat(t, 2:3:end)';
                    Z = obj.subjects{i}.traj_mat(t, 3:3:end)';
                    if i == 1                        
                        set(h1Plot,'XData',X,'YData',Y, 'ZData', Z);
                        hold on
                    else                        
                        set(h2Plot,'XData',X,'YData',Y, 'ZData', Z);
                        hold off
                    end
                    pause(0.001)
                end
            end
        end
        function plot_traj_sub(obj, sub)
            % This function plots the movement of a given subject of the
            % recording. Ths ubject needs to be specified
            % sub is the number of subject
            figure;
            h1Plot = plot3(NaN,NaN,NaN,'.r'); % Hand plot
            hold on
            axis('equal')
            pbaspect([1 1 1])            
            xlim([-400 800])
            ylim([200 1400])
            zlim([-700 500])
            xlabel('X')
            ylabel('Y')
            zlabel('Z')
            str = strcat('Trial:', '  ', obj.name(end-2: end));
            title(str)
            grid on            
            for t = 1: obj.n_smp                
                X = obj.subjects{sub}.traj_mat(t, 1:3:end)';
                Y = obj.subjects{sub}.traj_mat(t, 2:3:end)';
                Z = obj.subjects{sub}.traj_mat(t, 3:3:end)';
                set(h1Plot,'XData',X,'YData',Y, 'ZData', Z);
                hold on
                pause(0.001)
            end
        end
        function plot_traj_ax(obj, n, sc_f)            
            % sc_f is a scaling factor for the reference frame axes
            % sub is the subject for this plot
            fig1 = figure;
            h1Plot = plot3(NaN,NaN,NaN,'.r'); % Hand plot
            hold on
            h2Plot = plot3(NaN,NaN,NaN,'.b'); % Object plot
            h3Plot_ax = quiver3(NaN,NaN,NaN,NaN,NaN,NaN, 'c');
%             h3PlotX_ax = quiver3(NaN,NaN,NaN,NaN,NaN,NaN, 'b');
%             h3PlotY_ax = quiver3(NaN,NaN,NaN,NaN,NaN,NaN, 'g');
%             h3PlotZ_ax = quiver3(NaN,NaN,NaN,NaN,NaN,NaN, 'c');
            axis('equal')
            pbaspect([1 1 1])
            xlim([0 600])
            ylim([100 1000])
            zlim([-20 450])
            xlabel('X')
            ylabel('Y')
            zlabel('Z')
%             str = strcat('Trial:', '  ', obj.name(end-2: end));
%             title(str)
%             title('Complex Object Manipulation')
            view(25, 35);            
            set(fig1,'Position',[250 250 950 600])

            grid on
            ls = length(obj.subjects); % Number of subjects            
            if any(obj.subjects{n}.ax(4: 12, :) >= 1)
                obj.subjects{n}.ax(4: 12, :) = obj.subjects{n}.ax(4: 12, :);
            else
                obj.subjects{n}.ax(4: 12, :) = obj.subjects{n}.ax(4: 12, :)*sc_f;
            end   
            for t = 1: obj.n_smp
                for i = 1: ls
                    X = obj.subjects{i}.traj_mat(t, 1:3:end)';
                    Y = obj.subjects{i}.traj_mat(t, 2:3:end)';
                    Z = obj.subjects{i}.traj_mat(t, 3:3:end)';                    
                    if i == n                        
                        set(h1Plot,'XData',X,'YData',Y,'ZData',Z);  
                        ax_o = obj.subjects{i}.ax(1: 3, t);
                        ax_x = obj.subjects{i}.ax(4: 6, t);
                        ax_y = obj.subjects{i}.ax(7: 9, t);
                        ax_z = obj.subjects{i}.ax(10: 12, t);                        
                        set(h3Plot_ax, 'XData', [ax_o(1) ax_o(1) ax_o(1)], 'YData', [ax_o(2) ax_o(2) ax_o(2)], 'ZData', [ax_o(3) ax_o(3) ax_o(3)],...
                            'UData', [ax_x(1), ax_y(1), ax_z(1)], 'VData', [ax_x(2), ax_y(2), ax_z(2)], 'WData', [ax_x(3), ax_y(3), ax_z(3)]);                        
%                         set(h3PlotX_ax, 'XData', ax_o(1), 'YData', ax_o(2), 'ZData', ax_o(3), 'UData', ax_x(1), 'VData', ax_x(2), 'WData', ax_x(3));
%                         set(h3PlotY_ax, 'XData', ax_o(1), 'YData', ax_o(2), 'ZData', ax_o(3), 'UData', ax_y(1), 'VData', ax_y(2), 'WData', ax_y(3));
%                         set(h3PlotZ_ax, 'XData', ax_o(1), 'YData', ax_o(2), 'ZData', ax_o(3), 'UData', ax_z(1), 'VData', ax_z(2), 'WData', ax_z(3));
                        title(sprintf('Complet Object Manipulation N: %d',t))
                        hold on
                    else                        
                        set(h2Plot,'XData',X,'YData',Y, 'ZData', Z);
                        hold off
                    end
                    pause(0.000001)
                end
            end
        end
        function plot_snapshot_ax(obj, n, sc_f, in_smp, end_smp)            
            % sc_f is a scaling factor for the reference frame axes
            % sub is the subject for this plot
            % in_smp and end_smp are the initial and last samples of the
            % period of interest, respectively.
            fig1 = figure;
            h1Plot = plot3(NaN,NaN,NaN,'.r'); % Hand plot
            hold on
            h2Plot = plot3(NaN,NaN,NaN,'.b'); % Object plot
            h3PlotX_ax = quiver3(NaN,NaN,NaN,NaN,NaN,NaN, 'c');
            h3PlotY_ax = quiver3(NaN,NaN,NaN,NaN,NaN,NaN, 'g');
            h3PlotZ_ax = quiver3(NaN,NaN,NaN,NaN,NaN,NaN, 'b');
            axis('equal')
            pbaspect([1 1 1])            
            xlim([0 600])
            ylim([100 1000])
            zlim([-20 450])
            xlabel('X')
            ylabel('Y')
            zlabel('Z')
%             str = strcat('Trial:', '  ', obj.name(end-2: end));
%             title(str)
%             title('Complex Object Manipulation')
            view(25, 35);            
            set(fig1,'Position',[250 250 950 600])

            grid on
            ls = length(obj.subjects); % Number of subjects            
            if any(obj.subjects{n}.ax(4: 12, :) >= 1)
                obj.subjects{n}.ax(4: 12, :) = obj.subjects{n}.ax(4: 12, :);
            else
                obj.subjects{n}.ax(4: 12, :) = obj.subjects{n}.ax(4: 12, :)*sc_f;
            end               
            for t = in_smp: end_smp
                for i = 1: ls
                    X = obj.subjects{i}.traj_mat(t, 1:3:end)';
                    Y = obj.subjects{i}.traj_mat(t, 2:3:end)';
                    Z = obj.subjects{i}.traj_mat(t, 3:3:end)';                    
                    if i == n                        
                        set(h1Plot,'XData',X,'YData',Y,'ZData',Z);  
                        ax_o = obj.subjects{i}.ax(1: 3, t);
                        ax_x = obj.subjects{i}.ax(4: 6, t);
                        ax_y = obj.subjects{i}.ax(7: 9, t);
                        ax_z = obj.subjects{i}.ax(10: 12, t);                                             
                        set(h3PlotX_ax, 'XData', ax_o(1), 'YData', ax_o(2), 'ZData', ax_o(3), 'UData', ax_x(1), 'VData', ax_x(2), 'WData', ax_x(3));
                        set(h3PlotY_ax, 'XData', ax_o(1), 'YData', ax_o(2), 'ZData', ax_o(3), 'UData', ax_y(1), 'VData', ax_y(2), 'WData', ax_y(3));
                        set(h3PlotZ_ax, 'XData', ax_o(1), 'YData', ax_o(2), 'ZData', ax_o(3), 'UData', ax_z(1), 'VData', ax_z(2), 'WData', ax_z(3));
                        title(sprintf('Complet Object Manipulation N: %d',t))
                        hold on
                    else                        
                        set(h2Plot,'XData',X,'YData',Y, 'ZData', Z);
                        hold off
                    end
                    pause(0.000001)
                end
            end
        end
        function save_data(obj, n, name)
           % This function saves the data to an excel file to be further used
           nm = length(obj.subjects{n}.markers);                         
           m = [];
           ids = {};
           cnt = 0;
           cols = {};
           for i = 1: nm
               % Storing the markers information
               cnt = cnt + 1;
               m = [m, obj.subjects{n}.markers{i}.traj];
               ids{cnt} = obj.subjects{n}.markers{i}.id_mk;
               cols{cnt} = size(obj.subjects{n}.markers{i}.traj, 2);
           end
           nout = length(obj.subjects{n}.out_val);
           for i = 1: nout
               % Storing the output information
               cnt = cnt + 1;
               m = [m, obj.subjects{n}.out_val{i}.data'];
               ids{cnt} = obj.subjects{n}.out_names{i};
               cols{cnt} = size(obj.subjects{n}.out_val{i}.data, 1);
           end           
           ntot = size(m, 2); % Total amount of columns needed
           ids_fn = {};
           for i = 1: cnt
               tmp = cell(1, cols{i});
               tmp(:) = {ids{i}};
               ids_fn = horzcat(ids_fn, tmp); 
           end  
           m_cell = num2cell(m);
           record = vertcat(ids_fn, m_cell);
           cell2csv(strcat(name, '.csv'), record, ',');
           %% This section works well for Matlab 2020
%            abc = get_columns_for_excel(ntot); % Gathering a vector of the column names that will be used in excel           
%            ids = repelem(ids,1,3); % Repeat each element of the cell three times (three coordinates for each output)
%            writecell(ids, strcat(name, '.xlsx')); % Write the names of the variables
%            writematrix(m, strcat(name, '.xlsx'),'Sheet',1,'Range',strcat('A2', ':', abc(ntot), num2str(obj.n_smp + 1))); % Write the matrix under this titles
        end
   end
end