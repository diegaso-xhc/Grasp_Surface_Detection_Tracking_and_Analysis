% These are the dependencies required so that the whole framework works properly.
addpath('./HMCL_lib/') % Adds the dependencies required to run the VICON motion tracking system library and read recorded trials.
addpath('./Mesh_Manip_lib/') % Adds dependencies required to manipulate meshes, in the context of contact surfaces estimations.
addpath('./Info_objects/') % Adds objects information compressed in a .mat file. Objects' meshes have been standardized to 20.000 triangles.
addpath('./Track_object_lib/') % Adds dependencies to track an object in space, using reflective markers attached to them.
addpath('./Trials') % Makes all of the trials of the experiments visible for further usage.
load('markers_pos.mat') % Positions of the markers on the objects (recorded offline)
load('Objects_meshes.mat') % Mesh representations of all of the objects (20.000 triangles per object)
load('hand_mks_labels.mat') % Load labels for the hand markers that are used on our vicon tracking setup
