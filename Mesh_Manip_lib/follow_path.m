function out_trn = follow_path(TR, t1, t2, cntds, str)
% t1 is the initial triangle
% t2 is the destination triangle
% TR is the triangulation element containing the information from the mesh
% out_trn is a vector containing the rows on the TR element corresponding to the triangles along the path from t1 to t2
% cntds is a vector containing the centroids of all the triangles on the mesh
    it = 0; % We count the number of iterations
    flag = 0; % This flag let us know when we have reached the destination triangle
    while flag == 0 % 
        it = it + 1;
        out_trn(it, 1) = t1; % We store the indices of the triangles that are on the path from t1 to t2
        tmp_trn = find_neighbors(TR, t1, str); % We fine the closest triangles from the current triangle
        ln = length(tmp_trn);
        for i = 1: ln
            tmp_cntds(i, :) = cntds(tmp_trn(i), :); % We store the centroids of the triangles in a temporal vector
        end
        t1 = tmp_trn(dsearchn(tmp_cntds, cntds(t2, :))); % We calculate the distance from the destination triangle to the neighboring triangles of the current step
        while ismember(t1, out_trn) % In order to avoid infinite loops, we need to make sure we don't come back to a previous triangle
            [a,b] = find(tmp_trn == t1); 
            tmp_trn(a) = []; % Remove the triangle that is causing an endless loop
            tmp_cntds(a, :) = []; % Remove the centroid as well
            t1 = tmp_trn(dsearchn(tmp_cntds, cntds(t2, :))); % Calculate the the next triangle again
        end        
        if t1 == t2
            flag = 1; % If we have reached the final triangle
        end
    end
end