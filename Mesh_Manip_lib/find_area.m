function out_trn = find_area(TR, t, cntds, str)
% t is an array containing the points limiting the area
% TR is the triangulation element containing the information from the mesh
% out_trn is a vector containing the rows on the TR element corresponding to the triangles along the path from t1 to t2
% cntds is a vector containing the centroids of all the triangles on the mesh
n = length(t); % This is the number of points delimiting an area
for i = 1: n
    tmp_cntds(i, :) = cntds(t(i), :); % We store the centroids of the triangles in a temporal vector
end

% conn = zeros(n, 2);
% for i = 1: n
%     % We first arrange the points to build a contour on a mesh space (triangle numbers)
%     tmp_cntds_2 = tmp_cntds;
%     temp_vec = 1:n;
%     temp_vec(i) = [];
%     tmp_cntds_2(i, :) = [];
%     id = dsearchn(tmp_cntds_2, cntds(t(i), :)); % This returns the index of the first closest point
%     conn(i, 1) = temp_vec(id); % This returns the triangle 
%     temp_vec(id) = [];
%     tmp_cntds_2(id, :) = [];
%     conn(i, 2) = temp_vec(dsearchn(tmp_cntds_2, cntds(t(i), :))); % This returns the index of the second closest point   
% end
% 
% out_trn = 0;
% for i = 1: n
%    % We first build the contour on a mesh space (triangle numbers)
%    for j = 1: 2 % There are two connection points for each point
%        if i == 1 && j == 1
%            out_trn = follow_path(TR, t(i), t(conn(i, j)), cntds, str);
%        else
%            out_trn = [out_trn; follow_path(TR, t(i), t(conn(i, j)), cntds, str)];
%        end
%    end   
% end
% out_trn = unique(out_trn);

out_trn = 0;
it = 0;
for i = 1: n
   % We first build the contour on a mesh space (triangle numbers)
   for j = 1: n % There are two connection points for each point
       it = it + 1;
       if i ~= j
           if it == 2
               out_trn = follow_path(TR, t(i), t(j), cntds, str);
           else
               out_trn = [out_trn; follow_path(TR, t(i), t(j), cntds, str)];
           end          
       end
   end
end
out_trn = unique(out_trn);







end