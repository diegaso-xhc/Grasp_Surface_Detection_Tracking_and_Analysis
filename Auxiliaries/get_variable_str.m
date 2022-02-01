function [betas_str, fr_in_str, fr_end_str] = get_variable_str(betas, fr_in, fr_end)
% This function creates strings of the variables that are passed through
% the parser to Python3
n_b = length(betas);
betas_str = '';
for i = 1: n_b
    if i == n_b
        betas_str = strcat(betas_str, num2str(betas(i)));
    else
        betas_str = strcat(betas_str, num2str(betas(i)), " ");
    end    
end
fr_in_str = num2str(fr_in);
fr_end_str = num2str(fr_end);
end