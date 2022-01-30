function out_trn = select_area(TR, t, cntds, str)
% t is an array containing the points limiting the area
% TR is the triangulation element containing the information from the mesh
% out_trn is a vector containing the rows on the TR element corresponding to the triangles along the path from t1 to t2
% cntds is a vector containing the centroids of all the triangles on the mesh
n = length(t); % This is the number of points delimiting an area
v = 1: length(t); % Create a vector of n elements
comb = combnk(v,2); % We take all the combinations of two from the aforementioned vector
lc = size(comb, 1); % Number of combinations
it = 0; % NUmber of iterations
for i = 1: lc
    tmp_v = v; % We initialize a vector containing n elements
    tmp_v(comb(i, :)) = []; % We eliminate the current combination of elements
    tmp_trn = follow_path(TR, t(comb(i, 1)), t(comb(i, 2)), cntds, str); % We make the path between the current elements on the combination    
    ltmp = length(tmp_trn); % We get the size of the vector containing the triangles from two points
    for j = 1: n - 2 % We are always doing this for lines so we need to subtract 2 from the total size of the vector
        for k = 1: ltmp
            it = it + 1;
            if it == 1
                if tmp_trn(k) ~= t(tmp_v(j)) % We make sure we don't calculate the path between the same triangles
                    out_trn = follow_path(TR, tmp_trn(k), t(tmp_v(j)), cntds, str);
                else
                    out_trn = tmp_trn(k); % We add the current triangle nevertheless
                end
            else
                if tmp_trn(k) ~= t(tmp_v(j)) % We make sure we don't calculate the path between the same triangles
                    out_trn = [out_trn; follow_path(TR, tmp_trn(k), t(tmp_v(j)), cntds, str);]; % We add the new vectors to the resulting vector
                else
                    out_trn = [out_trn; tmp_trn(k)]; % We add the current triangle nevertheless
                end
            end
        end        
    end
end
out_trn = unique(out_trn); % We make sure we don't have redundant triangles on this vector
end