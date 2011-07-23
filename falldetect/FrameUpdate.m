%
% ECE 4007 - Spring 2009
%
% FrameUpdate.m
% Update the frame slider and index for the demo GUI
% Author: Nicholas Chan
% Date: March 3, 2009
%

function FrameUpdate

global STATE
% Get frame number parameter from the slidebar and load the appropriate
% frames
STATE.frameIndex = round(get(STATE.frame, 'Value'));
STATE.I = STATE.fg_smooth{STATE.frameIndex};
STATE.IS = STATE.fg_drawn{STATE.frameIndex};
STATE.MHI = STATE.motion_history{STATE.frameIndex};
STATE.theta = STATE.thetas(STATE.frameIndex);
STATE.rho = STATE.rhos(STATE.frameIndex);

% Normalize MHI for display
STATE.MHI = double(STATE.MHI);
STATE.MHI = STATE.MHI ./ 15;

%
% DISPLAY
%

% Display the filtered foreground segmentation image, STATE.I
STATE.aI = axes('Position', [0 .55 .49 .45]);
imshow(STATE.I);

% Display the filtered foreground segmentation image w/ ellipse, STATE.IS
STATE.aIS = axes('Position', [.51 .55 .49 .45]);
imshow(STATE.IS);

% Display the MHI image, STATE.MHI
STATE.aMHI = axes('Position', [0 0 .49 .45]);
imshow(STATE.MHI);

% Update STATE.frameLabel
set(STATE.frameLabel, 'String', sprintf('Frame #%g', STATE.frameIndex));

% Update STATE.thetaLabel
set(STATE.thetaLabel, 'String', sprintf('Orientation = %g', STATE.theta));

% Update STATE.rhoLabel
set(STATE.rhoLabel, 'String', sprintf('Eccentricity = %g', STATE.rho));



