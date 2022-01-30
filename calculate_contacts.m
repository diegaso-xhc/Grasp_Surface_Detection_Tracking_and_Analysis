function [yf_cell, yf_cell_nob, vert] = calculate_contacts(th, Y, ob, y_track)

object = {};
hand = {};
yf_cell = {};
y_cell = {};

load('verts_opt_V2_nob.mat')
load('faces_opt_V2_nob.mat')

vert_nob = order_imported_matrix_n_row_cols(output_vertices);
faces_nob = order_imported_matrix_n_row_cols(output_faces);

load('verts_opt_V2.mat')
load('faces_opt_V2.mat')

vert = order_imported_matrix_n_row_cols(output_vertices);
faces = order_imported_matrix_n_row_cols(output_faces);
%n_frames
ind = 209;
init_fr = 1;
end_fr = 1;
cnt = 0;

for i = init_fr: end_fr
    cnt = cnt + 1;  
    object{1} = triangulation(Y{ob, 1}, y_track{i});
    hand{1} = triangulation(double(faces{i} + 1), vert{i});
    [yf y] = getContactSurfaces(object, hand, th, 'near');
    yf_cell{cnt} = yf;
    y_cell{cnt} = y;
    cnt
end

yf_cell_nob = {};
y_cell_no = {};
cnt = 0;
for i = init_fr: end_fr
    cnt = cnt + 1;  
    object{1} = triangulation(Y{ob, 1}, y_track{i});
    hand{1} = triangulation(double(faces_nob{i} + 1), vert_nob{i});
    [yf y] = getContactSurfaces(object, hand, th, 'near');
    yf_cell_nob{cnt} = yf;
    y_cell_no{cnt} = y;
    cnt
end


end