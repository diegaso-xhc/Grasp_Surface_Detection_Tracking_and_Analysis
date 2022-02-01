function T = order_imported_matrix_n_row_cols(X)
% This function receives 3 dimensional vectores, where the 1st position is
% the iteration (in this case, frame of motion tracking) n, 2nd dimension is
% the number of rows and 3rd is the number of coordinates of said rows (for
% example x, y, z. As an example:
% size(A) = [10, 100, 3], means there are 10 samples of a matrix of 100x3
% T is a 1 by n cell containing all of the matrices (100x3 on the example)
n = size(X, 1);
r = size(X, 2);
c = size(X, 3);
T = {};
for i = 1: n   
    if r > c
        T{i} = squeeze(X(i,:,:));
    else
        T{i} = squeeze(X(i,:,:))';
    end
end

end