%
% ECE 4007 - Spring 2009
%
% SmoothTest.m
%
% Author: Nicholas Chan
% Date: February 13, 2009
%

function SmoothTest(fg)

global STATE

% Because I suck at passing variables into functions
STATE.fg = fg;

% Analyze the 30th (this choice is arbitrary) frame by default
STATE.numFrames = length(fg);
STATE.frameIndex = 30;
I = fg{STATE.frameIndex};

%Get the size of the chosen frame
[STATE.M STATE.N] = size(I);

% Normalize the image intensities
STATE.I = double(I);
% STATE.I = STATE.I - min(min(STATE.I));
% STATE.I = STATE.I / max(max(STATE.I));

% Set default Gaussian smoothing parameters
STATE.k = 5;   % Set to 5 by default
STATE.w = 11;   % WINDOW SIZE - Set to 2k+1 = 11 by default
STATE.sigma = 2.2;   % Set to w/5 = 2.2 by default

% Compute the Gaussian Smoothing Kernel and convolve the image with it
GKernel = Gaussian_Smoothing_Kernel(STATE.w);
STATE.IS = filter2(GKernel, STATE.I);

% Threshold the smoothed image intensities
threshold = 0.7; % Threshold set to 0.7 by default
for y = 1:STATE.M
    for x = 1:STATE.N
        if STATE.IS(y,x) < threshold
            STATE.ISG(y,x) = 0;
        else
            STATE.ISG(y,x) = 255;
        end
    end
end

%
% DISPLAY
%

STATE.fig = figure('Name', 'SmoothTest', 'NumberTitle', 'off', 'MenuBar', 'none', 'Units', 'normalized');

% Display the original image, STATE.I
STATE.aI = axes('Position', [0 .55 .49 .45]);
imshow(STATE.I);

% Display the smoothed image, STATE.IS
STATE.aIS = axes('Position', [.51 .55 .49 .45]);
imshow(STATE.IS);

% Display the thresholded image, STATE.ISG
STATE.aISG = axes('Position', [0 0 .49 .45]);
imshow(STATE.ISG);

% Display the filter size slidebar, STATE.fsize
STATE.fsize = uicontrol('Style', 'slider', 'Units', 'normalized', 'Position', [0.6 .43 .3 .04], 'Min', 0, 'Max', 15, 'Value', 5, 'Callback', 'Resmooth');

% Display the threshold value slidebar, STATE.tsize
STATE.tsize = uicontrol('Style', 'slider', 'Units', 'normalized', 'Position', [0.6 .28 .3 .04], 'Min', 0, 'Max', 1, 'Value', 0.7, 'Callback', 'Resmooth');

% Display the frame number slidebar, STATE.tsize
STATE.isize = uicontrol('Style', 'slider', 'Units', 'normalized', 'Position', [0.6 .13 .3 .04], 'Min', 1, 'Max', STATE.numFrames, 'Value', 30, 'Callback', 'Resmooth');

% Display the label for the filter size, STATE.fsize_label (11 by default)
STATE.aFSIZE = axes('Position', [0.6 .38 .1 .04]);
axis off;
STATE.fsize_label = text(.5, .5, 'Filter Size = 11', 'Units', 'normalized', 'HorizontalAlignment', 'left');

% Display the label for the threshold value, STATE.tsize_label (0.7 by default)
STATE.aTSIZE = axes('Position', [0.6 .23 .1 .04]);
axis off;
STATE.tsize_label = text(.5, .5, 'Threshold = 0.7', 'Units', 'normalized', 'HorizontalAlignment', 'left');

% Display the label for the threshold value, STATE.frameIndex (30 by default)
STATE.aISIZE = axes('Position', [0.6 .08 .1 .04]);
axis off;
STATE.isize_label = text(.5, .5, 'Frame #30', 'Units', 'normalized', 'HorizontalAlignment', 'left');





