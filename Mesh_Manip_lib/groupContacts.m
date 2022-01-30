function y = groupContacts(obj, vec, ind)
% This function allows us to group the contact surfaces on groups.
% Basically, a set of triangles is received and this function checks
% which triangles are connected to one another and group them together.
tmp_tr = triangulation(obj.ConnectivityList(vec, :), obj.Points); % Create a triangulation only with the triangles of interest, but with the points of the full object
ed = edges(tmp_tr); % Find a nx2 vector which contains the connections on the given triangulation of interest
tmp_ed = unique([ed(:,1);ed(:,2)]); % We get all of the points of interest from the edge matrix 
y = {}; % Resulting contact regions
i = 0; % Number of contact region
while 1
    i = i + 1; % Number of contact region    
    y{i}(1) = tmp_ed(1); % First element on the vector containing all of the points we are concerned with
    while 1               
        [a, b] = ismember(ed, y{i}); % We check all of the places where the elements on ed where there is a match with the elements on Y
        I1 = (a(:, 1) == 1 & a(:, 2) == 0); % If there is a match but the connected element is not added, we add it (we know ed has two columns)
        if any(I1)
           y{i} = unique([y{i} ed(find(I1 == 1), 2)']); % We take the corresponding elements on the complementary index, in this case 2         
        end
        I2 = (a(:, 1) == 0 & a(:, 2) == 1); % If there is a match but the connected element is not added, we add it (we know ed has two columns)
        if any(I2)
           y{i} = unique([y{i} ed(find(I2 == 1), 1)']); % We take the corresponding elements on the complementary index, in this case 1
        end
        if ~any(I1) && ~any(I2) % If there are no more combinations [1 0] or [0 1], it means that either all of the elements are taken and the contact surface is complete           
           break; 
        end        
    end
    [b, loc] = ismember(y{i}, tmp_ed); % We check whether the elements on the contact surface are on the original tmp_ed vector we created before
    loc(loc == 0) = []; % We gather the locations where repeated elements might be
    tmp_ed(loc) = []; % We delete this elements so we can generate surface contacts with the remaining points
    if isempty(tmp_ed) % If after deleting the points from a contact surface, the vector is empty, it means we have finished grouping all of the points.
        l = length(y);
        for j = 1: l
            y{j} = y{j}(find(ismember(y{j}, ind) == 1)); % We make sure we only consider the points we need and not the ones of the triangles around them
        end        
        i = 0;
        break;
    end
end


end