%
% ECE 4007 - Spring 2009
%
% removeNoise.m
%
% Author: Nicholas Chan
% Date: February 16, 2009
%

function K = removeNoise(fg)

global STATE

% Initialize the output, the smoothed set of frames, K
K = fg;

% Set default Gaussian smoothing parameters
STATE.k = 5;   % Set to 5 by default
STATE.w = 11;   % WINDOW SIZE - Set to 2k+1 = 11 by default
STATE.sigma = 2.2;   % Set to w/5 = 2.2 by default

% Compute the Gaussian Smoothing Kernel
GKernel = Gaussian_Smoothing_Kernel(STATE.w);

%Start global loop for each frame
for frameIndex = 1:length(fg)
    
    % Load current frame from image cell
    frame = fg{frameIndex};
    
    % Compute frame size
    [STATE.M STATE.N] = size(frame);
    
    % Smooth current frame
    frame = filter2(GKernel, frame);
    
    % Threshold the smoothed frame
    threshold = 0.7; % Threshold set to 0.7 by default
    for y = 1:STATE.M
        for x = 1:STATE.N
            if frame(y,x) < threshold
                K{frameIndex}(y,x) = 0;
            else
                K{frameIndex}(y,x) = 1;
            end
        end
    end
end
    
    