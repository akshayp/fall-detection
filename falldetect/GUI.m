%
% ECE 4007 - Spring 2009
%
% GUI.m
% Demonstration GUI to display frame by frame output of the functions
% Author: Nicholas Chan
% Date: March 3, 2009
%

function GUI()

clear all;

global STATE

load Matrices\frames.mat;
load Matrices\fg_drawn.mat;
load Matrices\motion_history.mat;
load Matrices\thetas.mat;
load Matrices\rhos.mat;

fg_smooth = frames;
STATE.fg_smooth = fg_smooth;
STATE.fg_drawn = fg_drawn;
STATE.motion_history = motion_history;
STATE.thetas = thetas;
STATE.rhos = rhos;

%
% DISPLAY
%

% Analyze the 1st (this choice is somewhat arbitrary) frame by default
STATE.frameIndex = 1;

STATE.fig = figure('Name', 'Fall Detection GUI', 'NumberTitle', 'off', 'MenuBar', 'none', 'Units', 'normalized');
STATE.I = fg_smooth{STATE.frameIndex};
STATE.IS = fg_drawn{STATE.frameIndex};
STATE.MHI = motion_history{STATE.frameIndex};
STATE.theta = thetas(STATE.frameIndex);
STATE.rho = rhos(STATE.frameIndex);

% Get the number of frames in the video
STATE.numFrames = length(fg_smooth);

%Get the size of the chosen frame(s)
[STATE.M STATE.N] = size(STATE.I);

% Normalize MHI for display
STATE.MHI = double(STATE.MHI);
STATE.MHI = STATE.MHI ./ 15;

% Display the filtered foreground segmentation image, STATE.I
STATE.aI = axes('Position', [0 .55 .49 .45]);
imshow(STATE.I);

% Display the filtered foreground segmentation image w/ ellipse, STATE.IS
STATE.aIS = axes('Position', [.51 .55 .49 .45]);
imshow(STATE.IS);

% Display the MHI image, STATE.MHI
STATE.aMHI = axes('Position', [0 0 .49 .45]);
imshow(STATE.MHI);


% Display the frame number slidebar, STATE.frame
STATE.frame = uicontrol('Style', 'slider', 'Units', 'normalized', 'Position', [0.6 .13 .3 .04], 'Min', 1, 'Max', STATE.numFrames, 'Value', 1, 'Callback', 'FrameUpdate');

% Display the label for the frame value, STATE.frame (30 by default)
STATE.aFRAME = axes('Position', [0.6 .08 .1 .04]);
axis off;
STATE.frameLabel = text(.5, .5, 'Frame #1', 'Units', 'normalized', 'HorizontalAlignment', 'left');

% Display the label for the theta value, STATE.theta
STATE.aTHETA = axes('Position', [0.6 .23 .1 .04]);
axis off;
% STATE.thetaLabel = uicontrol('Style', 'edit', 'Position', [0.6 .23 .3 .04], 'String', 'Orientation = ');
STATE.thetaLabel = text(.5, .5, 'Orientation = ?', 'Units', 'normalized', 'HorizontalAlignment', 'left');

% Display the label for the rho value, STATE.rho
STATE.aRHO = axes('Position', [0.6 .33 .1 .04]);
axis off;
% STATE.rhoLabel = uicontrol('Style', 'edit', 'Position', [0.6 .33 .3 .04], 'String', 'Eccentricity = ');
STATE.rhoLabel = text(.5, .5, 'Eccentricity = ?', 'Units', 'normalized', 'HorizontalAlignment', 'left');






