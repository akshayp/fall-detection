%
% ECE 4007 - Spring 2009
%
% MHI.m
% Calculates the Motion History Image of the given video input
% Author: Nicholas Chan
% Date: February 16, 2009
%
% Assumptions: 15 FPS data; T = 15 frames (1 second) per fall

function MHI = MHI(fg)

% Initialize the output, MHI a.k.a. H(x,y,t,T)
MHI = fg;

% Define MHI parameter T
T = 15; % # of frames being considered; maximal value of MHI.

% Load the first frame
frame1 = fg{1};

% Get dimensions of the frames
[y_max x_max] = size(frame1);

% Compute H(x,y,1,T) (the first MHI)
MHI{1} = fg{1} .* T;

%Start global loop for each frame
for frameIndex = 2:length(fg)
    
    %Load current frame from image cell
    frame = fg{frameIndex};
    
    %Begin looping through each point
    for y = 1:y_max
        for x = 1:x_max
            if (frame(y,x) == 255)
                MHI{frameIndex}(y,x) = T;
            else
                if (MHI{frameIndex-1}(y,x) > 1)
                    MHI{frameIndex}(y,x) = MHI{frameIndex-1}(y,x) - 1;
                else
                    MHI{frameIndex}(y,x) = 0;
                end
            end
        end
    end
end
    
    
    