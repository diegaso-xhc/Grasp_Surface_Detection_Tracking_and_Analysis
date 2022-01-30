function plotContactRegions(y, col_vec)
nfgs = size(y, 2);
for j = 1: nfgs
    ncs = length(y{j});
    for k = 1: ncs
        y{j}{k}.plotPoints(1, col_vec);
        y{j}{k}.plotNormals(1);
        hold on
    end
end
end
