function out_trn = find_neighbors(TR, n, str)
% n is the number of triangle (row) of the triangulation element
% TR is a triangulation element containing the information from the mesh
% out_trn is a vector containing the rows on the TR element corresponding to the neighboring triangles
if strcmp(str, 'side')
   r = 0;
   cl = 0;
   for i = 1: 3
       id = [1 2; 2 3; 1 3]; % These are the sides from a vertex perspective
       [a, b] = find(TR.ConnectivityList == TR.ConnectivityList(n, id(i, 1))); % Find rows that match the first vertex
       [c, d] = find(TR.ConnectivityList == TR.ConnectivityList(n, id(i, 2))); % Find rows that match the second vertex
       tmp_r = intersect(a,c); % Fins the rows that match both vertices
       if i == 1
           r = tmp_r;            
       else
           r = [r; tmp_r]; % Attach the results from all the sides           
       end
   end 
   out_trn = r(r~=n); % Make sure we don't count the current triangle   
elseif strcmp(str, 'vertex')
   r = 0;
   cl = 0;
   for i = 1: 3
       id = TR.ConnectivityList(n, i);
       [tmp_r, tmp_cl] = find(TR.ConnectivityList == id); % Find the rows that match the corresponding vertex
       if i == 1
           r = tmp_r;
           cl = tmp_cl;
       else
           r = [r; tmp_r]; % Attach the results from all the vertices
           cl = [cl; tmp_cl]; 
       end
   end 
   out_trn = r(r~=n); % Make sure we don't count the current triangle
end

end