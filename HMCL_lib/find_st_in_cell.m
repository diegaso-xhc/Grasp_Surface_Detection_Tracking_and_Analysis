% Developed by Diego Hidalgo C.

function ind = find_st_in_cell(c, st, ncl)
% This function returns the index of a string on a given cell which
% contains multiple strings, as for example on the model output names of
% the vicon trials

% c is a cell containing strings 
% st is the string we need to compare it to
% ncl is the column where the string could be located
if nargin == 2   
    % In case there is a one dimensional cell
    ind = find(not(cellfun('isempty', strfind(c, st)))); 
elseif nargin == 3
    % In case there is a mul
    tmp = {};
    ln = size(c, 1); % rows in the cell array
    for i = 1: ln
        tmp{i} = c{i, ncl};
    end
    ind = find(not(cellfun('isempty', strfind(tmp, st))));
end
end