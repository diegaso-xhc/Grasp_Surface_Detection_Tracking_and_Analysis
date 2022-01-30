function [yf, y] = getContactSurfaces(obj, fings, th, type_op)
% This function receives triangulations or cells of triangulations. Then it
% plots or returns the contact regions on the object, depending on the
% fingers and their positions with respect to the object and a given
% threshold.
%
% obj is the triangulation of the object
% fings is a cell of triangulations that are in contact with the object
% th is a threshold of the distance from the surface of the object to the
%   fingers and it can be customized to improve accuracy on the contact
%   region
n1 = length(obj); % Number of objects
shp_obj = {}; % A cell which will contain all of the alpha shapes
for i = 1: n1
    shp_obj{i} =  alphaShape(obj{i}.Points); % We define an alpha shape for each triangulation of the objects
end
n2 = length(fings); % Number of fingers
shp_fings = {}; % A cell containing the alpha shapes of the fingers
for i = 1: n2
    shp_fings{i} = alphaShape(fings{i}.Points); % We define an alpha shape for each triangulation of the fingers
end
in_d = cell(n1, n2, 2); % This is a cell which will contain the information on the nearest points and the distances from the object, given a threshold
p = cell(n1, n2); % A cell containing the contact points between the each object and the fingers
y = {{}};
for i = 1: n1    
    for j = 1: n2
        if strcmp(type_op, 'near')
            neigh = 2;
            for t = 1: neigh
%                 [in_d{i, j, 1}, in_d{i, j, 2}] = knnsearch(obj{i}.Points, fings{j}.Points, 'K', neigh); % We calculate the nearest neighbors on the object to the fingers
                [in_d{i, j, 1}, in_d{i, j, 2}] = knnsearch(obj{i}.Points, fings{j}.Points, 'K', neigh, 'Distance', 'euclidean'); % We calculate the nearest neighbors on the object to the fingers
                % the following if statement allows us to add all of the
                % k-nearest neighbors to a single vector for further
                % processing
                if t == 1
                    tmp_1 = in_d{i, j, 1}(:, 1);
                    tmp_2 = in_d{i, j, 2}(:, 1);
                else
                    tmp_1 = [tmp_1; in_d{i, j, 1}(:, t)];
                    tmp_2 = [tmp_2; in_d{i, j, 2}(:, t)];
                end
                in_d{i, j, 1} = tmp_1;
                in_d{i, j, 2} = tmp_2;              
                in_d{i, j, 1} = in_d{i, j, 1}(find(in_d{i, j, 2} < th)); % Given a certain threshold, we remove the points which are too far away
                in_d{i, j, 2} = in_d{i, j, 2}(find(in_d{i, j, 2} < th)); % Given a certain threshold, we remove the points which are too far away
                [in_d{i, j, 1}, tempa, tempc] = unique(in_d{i, j, 1}); % Gathering he unique vector and further using the indices from it
                in_d{i, j, 2} = in_d{i, j, 2}(tempa, :);
                p{i, j} = obj{i}.Points(in_d{i, j, 1}, :); % We add the contact points to the aforementioned cell p
                indices = in_d{i, j, 1}; % This is important to later find the triangles connected to a given point
            end                                
        elseif strcmp(type_op, 'in')
            [in_d{i, j, 1}, in_d{i, j, 2}] = inShape(shp_fings{j}, obj{i}.Points); % We check if there are points on the object which are inside the fingers
            indices = find(in_d{i, j, 1} == 1); % We get the indices of the points which are inside
            in_d{i, j, 1} = in_d{i, j, 1}(indices); % We filter the points depending on these points
            in_d{i, j, 2} = in_d{i, j, 2}(indices); % We filter the points depending on these points
            p{i, j} = obj{i}.Points(indices, :); % We add the contact points to the aforementioned cell p
        elseif strcmp(type_op, 'both')
            neigh = 2;
            for t = 1: neigh
                [in_d{i, j, 1}, in_d{i, j, 2}] = knnsearch(obj{i}.Points, fings{j}.Points, 'K', neigh); % We calculate the nearest neighbors on the object to the fingers
                % the following if statement allows us to add all of the
                % k-nearest neighbors to a single vector for further
                % processing
                if t == 1
                    tmp_1 = in_d{i, j, 1}(:, 1);
                    tmp_2 = in_d{i, j, 2}(:, 1);
                else
                    tmp_1 = [tmp_1; in_d{i, j, 1}(:, t)];
                    tmp_2 = [tmp_2; in_d{i, j, 2}(:, t)];
                end
                in_d{i, j, 1} = tmp_1;
                in_d{i, j, 2} = tmp_2;              
                in_d{i, j, 1} = in_d{i, j, 1}(find(in_d{i, j, 2} < th)); % Given a certain threshold, we remove the points which are too far away
                in_d{i, j, 2} = in_d{i, j, 2}(find(in_d{i, j, 2} < th)); % Given a certain threshold, we remove the points which are too far away
                [in_d{i, j, 1}, tempa, tempc] = unique(in_d{i, j, 1}); % Gathering he unique vector and further using the indices from it
                in_d{i, j, 2} = in_d{i, j, 2}(tempa, :);
                indices_tmp = in_d{i, j, 1}; % This is important to later find the triangles connected to a given point
            end               
                [in_d{i, j, 1}, in_d{i, j, 2}] = inShape(shp_fings{j}, obj{i}.Points); % We check if there are points on the object which are inside the fingers
                indices = find(in_d{i, j, 1} == 1); % We get the indices of the points which are inside
                in_d{i, j, 1} = in_d{i, j, 1}(indices); % We filter the points depending on these points
                in_d{i, j, 2} = in_d{i, j, 2}(indices); % We filter the points depending on these points                
                indices = unique([indices; indices_tmp]);
                p{i, j} = obj{i}.Points(indices, :); % We add the contact points to the aforementioned cell p          
        end
        
        %%%%%%%%%% Get triangles related to the points of interest%%%%%%%%%
        v = vertexAttachments(obj{i}, indices); % returns the IDs of the triangles or tetrahedra attached to the vertices specified in indices.
        % The vertex IDs in indices are the row numbers of the corresponding vertices in obj.Points.
        % The following code lines allow us to get a unique set of
        % triangles depending on the given set of points of interest
        lv = length(v);
        vec = {};
        
        if lv~= 0
            vec{j} = v{1, :};
            for t = 2: lv
                vec{j} = [vec{j}, v{t, :}];
            end
            vec{j} = unique(vec{j});  
            tmp_y = groupContacts(obj{i}, vec{j}, indices);
            for k = 1: length(tmp_y)
                y{i}{j}{k} = ContactSurface(obj{i}, tmp_y{k});                
            end
        else
            y{i}{j} = [];
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%              
    end
           
end
% yf = filterContacts_v3(y, n1, n2, obj, fings);  
yf = y;
end