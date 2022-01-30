% Developed by Diego Hidalgo C.

% Demo to create a movie file from a Gaussian and then optionally save it to disk as an avi video file.

%==============================================================================================
% Initialization code
clear all;
clc;
workspace;
st1 = Study(1500, 3500);
numberOfFrames = st1.n_smp;
x1d = linspace(-3, 3, numberOfFrames);
y1d = x1d;
t = linspace(0, 5, numberOfFrames);
hFigure = figure;

% Set up the movie structure.
% Preallocate movie, which will be an array of structures.
% First get a cell array with all the frames.
allTheFrames = cell(numberOfFrames,1);
vidHeight = 344;
vidWidth = 446;
allTheFrames(:) = {zeros(vidHeight, vidWidth, 3, 'uint8')};
% Next get a cell array with all the colormaps.
allTheColorMaps = cell(numberOfFrames,1);
allTheColorMaps(:) = {zeros(256, 3)};
% Now combine these to make the array of structures.
myMovie = struct('cdata', allTheFrames, 'colormap', allTheColorMaps);
% Create a VideoWriter object to write the video out to a new, different file.
% writerObj = VideoWriter('problem_3.avi');
% open(writerObj);
% Need to change from the default renderer to zbuffer to get it to work right.
% openGL doesn't work and Painters is way too slow.
set(gcf, 'renderer', 'zbuffer');

%==============================================================================================
% Create the movie.
% Get a list of x and y coordinates for every pixel in the x-y plane.
[x, y] = meshgrid(x1d, y1d);
% After this loop starts, BE SURE NOT TO RESIZE THE WINDOW AS IT'S SHOWING THE FRAMES, or else you won't be able to save it.


for frameIndex = 1 : numberOfFrames
	z = exp(-(x-t(frameIndex)).^2-(y-t(frameIndex)).^2);
	cla reset;
	% Enlarge figure to full screen.
% 	set(gcf, 'Units', 'Normalized', 'Outerposition', [0, 0, 1, 1]);
%     X = st1.subjects{i}.traj_mat(t, 1:3:end)';
%     Y = st1.subjects{i}.traj_mat(t, 2:3:end)';
%     Z = st1.subjects{i}.traj_mat(t, 3:3:end)';
    surf(x,y,z);
	axis('tight')
	zlim([0, 1]);
	caption = sprintf('Frame #%d of %d, t = %.1f', frameIndex, numberOfFrames, t(frameIndex));
	title(caption, 'FontSize', 15);
	drawnow;
	thisFrame = getframe(gca);
	% Write this frame out to a new video file.
%  	writeVideo(writerObj, thisFrame);
	myMovie(frameIndex) = thisFrame;
end
% close(writerObj);

%==============================================================================================
% See if they want to replay the movie.
message = sprintf('Done creating movie\nDo you want to play it?');
button = questdlg(message, 'Continue?', 'Yes', 'No', 'Yes');
drawnow;	% Refresh screen to get rid of dialog box remnants.
close(hFigure);
if strcmpi(button, 'Yes')
	hFigure = figure;
	% Enlarge figure to full screen.
	% set(gcf, 'Units', 'Normalized', 'Outerposition', [0, 0, 1, 1]);
	title('Playing the movie we created', 'FontSize', 15);
	% Get rid of extra set of axes that it makes for some reason.
	axis off;
	% Play the movie.
	movie(myMovie);
	close(hFigure);
end
