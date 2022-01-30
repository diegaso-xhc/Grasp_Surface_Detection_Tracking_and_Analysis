% Developed by Diego Hidalgo C.

function y = get_columns_for_excel(n)
% This function returns a vector of strigns with the names of the columns
% depending on a number of columns we need
y = [];
abc = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M",...
    "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"];
tmp = 1: 26: n;
l_tmp = length(tmp);
for i = 1: l_tmp
    if i == 1
        y = [y, abc];
    else
        y = [y, strcat(abc(i - 1), abc)]; % Solution on adding a letter at the beginning of each letter of the abecedary
    end
end
end