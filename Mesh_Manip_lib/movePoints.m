function xr = movePoints(x, th, ax, d)
% This function takes a set of points and rotates them with respect to one
% of the three cartesian axes

% x are the original points in the format of n x 3
% th is the angle of rotation in degrees
% ax is the axis of rotation (1 for x, 2 for y and 3 for z)
% d is a displacement vector
x = x'; % We set the points to the format of 3 x n
if nargin == 4
    th = th*pi/180; % We set the angle in radians
    if numel(ax) == 1
        if ax == 1
            R = [1 0 0; 0 cos(th) -sin(th); 0 sin(th) cos(th)];
        elseif ax == 2
            R = [cos(th) 0 sin(th); 0 1 0; -sin(th) 0 cos(th)];
        else
            R = [cos(th) -sin(th) 0; sin(th) cos(th) 0; 0 0 1];
        end
    elseif numel(ax) == 3
        R = rod_rotation(ax, th); % In case the ax is already specified as a matrix
    end     
    if size(d, 2) == 3
        d = d';
    end
    T = [R, d];
    T = [T; [0 0 0 1]];
elseif nargin == 2
    if numel(th) == 16
        % In this case the input is already a rotation matrix
        T = th;        
    end
end
x(4, :) = 1;
xr = T*x;
xr = xr'; % The points are returned in the same format as the input n x 3
xr = xr(:, 1:3); % We remove the last column as it does not represent the points themselves
end