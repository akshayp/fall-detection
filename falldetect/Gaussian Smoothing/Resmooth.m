%
% ECE 4007 - Spring 2009
%
% Resmooth.m
%
% Author: Nicholas Chan
% Date: February 13, 2009
%

function Resmooth

global STATE

% Get frame number parameter from the slidebar and load the frame
STATE.frameIndex = round(get(STATE.isize, 'Value'));
I = STATE.fg{STATE.frameIndex};

% Normalize the image intensities
STATE.I = double(I);
% STATE.I = STATE.I - min(min(STATE.I));
% STATE.I = STATE.I / max(max(STATE.I));

% Get the Gaussian smoothing parameters from the slidebar
STATE.k = round(get(STATE.fsize, 'Value'));
STATE.w = 2*STATE.k + 1;
STATE.sigma = STATE.w/5;

% Get threshold parameter from the slidebar
STATE.threshold = get(STATE.tsize, 'Value');

% Compute the Gaussian Smoothing Kernel and convolve the image with it
GKernel = Gaussian_Smoothing_Kernel(STATE.w);
STATE.IS = filter2(GKernel, STATE.I);

% Threshold the smoothed image intensities
for y = 1:STATE.M
    for x = 1:STATE.N
        if STATE.IS(y,x) < STATE.threshold
            STATE.ISG(y,x) = 0;
        else
            STATE.ISG(y,x) = 255;
        end
    end
end

%
% DISPLAY
%

% Display the original image, STATE.I
STATE.aI = axes('Position', [0 .55 .49 .45]);
imshow(STATE.I);

% Display the smoothed image, STATE.IS
STATE.aIS = axes('Position', [.51 .55 .49 .45]);
imshow(STATE.IS);

% Display the thresholded image, STATE.ISG
STATE.aISG = axes('Position', [0 0 .49 .45]);
imshow(STATE.ISG);

% Update STATE.fsize_label
set(STATE.fsize_label, 'String', sprintf('Filter Size = %g', STATE.w));

% Update STATE.tsize_label
set(STATE.tsize_label, 'String', sprintf('Threshold = %g', STATE.threshold));

% Update STATE.isize_label
set(STATE.isize_label, 'String', sprintf('Frame #%g', STATE.frameIndex));



