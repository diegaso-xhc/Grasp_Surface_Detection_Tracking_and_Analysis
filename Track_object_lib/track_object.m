function y = track_object(objt, poi, p)
% This function takes the information of an object in space and tracks it
% according to the positions of 4 markers, which correspond to the poi on
% the object
%
% objt is the object the function needs to track
% poi is a 4x1 matrix containing the indices of the points of interest on the object (where markers are placed)
% p is an nx12 matrix of points which represents the motion of the 4 poi per frame 
% in a given time
nf = size(p, 1); % Number of frames
y = {}; % Cell containing all of the points on each one of the frames
% Get basis vectors for this particular object. The basis vectors are
% defined as the vectors of markers on frame No.1
in_p = objt.p - objt.p(poi(1), :);
b1 = in_p(poi(2), :) - in_p(poi(1), :);
b2 = in_p(poi(3), :) - in_p(poi(1), :);
b3 = in_p(poi(4), :) - in_p(poi(1), :);
C = [b1' b2' b3']; % Change of basis matrix
for i = 1: nf
  % main loop
  tmp_p = in_p; % Initialize the points as the original mesh 
  fb1 = p(i, 4:6) - p(i, 1:3);
  fb2 = p(i, 7:9) - p(i, 1:3);
  fb3 = p(i, 10:12) - p(i, 1:3);
  D = [fb1' fb2' fb3']; % Transformation matrix on standard frame
  D_in_b = C\D; % Transformation matrix on the new frame  
  tmp_p = (C\tmp_p')'; % We translate all of the points to the new basis
  tmp_p = (D_in_b*tmp_p')'; % We rotate the object in this new basis frame
  tmp_p = (C*tmp_p')'; % We translate the points back to the standard basis
  y{i} = tmp_p + p(i, 1:3); % Store the rotated points corresponding to the given frame 
end
end