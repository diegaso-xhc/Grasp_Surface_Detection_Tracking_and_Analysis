function np = coortrans(M, p, s)
% This function transforms the coordinates of a point based on an 4x4
% transformation matrix
% M is the transformation matrix
% p is the list of points to be transformed and it must be an 3xn matrix
% s is an integer (1 for horizontal matrix or 2 for vertical matrix);
if nargin == 2
    p(4, :) = 1; % By default the point is assumed to be horizontal    
else
    if s == 1
        p(4, :) = 1; % If the points are represented in an 3xn matrix        
    else
        p(:, 4) = 1; % If the points are represented in an nx3 matrix
        p = p';       
    end
end
np = M*p;
np = np(1:3, :); % Just returning the coordinates of the new points
if s ~= 1
    np = np'; % If the points are represented in an nx3 matrix
end
end
