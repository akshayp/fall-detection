%
% ECE 4007 - Spring 2009
%
% centroid.m
% Calculate center of mass of detected blob from foreground

% INPUT: Image cell array of dimensinos 1xNumOfFrames, where each
% cell is a matrix of dimensions MxN that represents one frame of the video

% OUTPUT: A NumOfFrames*2 array called centroid_array, where
% centroid_array(F,1) and centroid(F,2) give the respective x and y 
% centroid coordinates of frame 'F'
% Author: Abhishek Chandrashekhar
% Date: February 23, 2009

function centroid_array = centroid(fg)
 
%Define Number of Frames
NumOfFrames = length(fg);

%Define the output, centroid_array
centroid_array = zeros(NumOfFrames,2);

%Start global loop for each frame
for frameIndex = 1:NumOfFrames
    
    %Load current frame from image cell
    frame = fg{frameIndex};
    
 
    %Get dimensions of the frame
    [y_max x_max] = size(frame);
    
    %NOTE:
    %CENTROID = SUM(mass of the point * position of the point) / SUM(mass
    %of the point)
    
    %Define the weighted mass, which is the product of each 'mass' weighted
    %by it's position
    WeightedMass_X = 0;
    WeightedMass_Y = 0;
    
    %Define the sum of masses, a variable to be used in upcoming loop
    %In this case, the 'mass' of each point is either 1 or 0, so the sum of
    %the masses will effectively be the sum of all the 1's in the frame, or
    %equivalently, the number of 1's in the frame.
    SumOfMasses = 0;
    
    %Begin looping through each point
    for y = 1:y_max
        for x = 1:x_max
                      
            
            %X Dimension
            WeightedMass_X = WeightedMass_X + frame(y,x)*x;
            
            %Y Dimension
            WeightedMass_Y = WeightedMass_Y + frame(y,x)*y;
            
            SumOfMasses = SumOfMasses + frame(y,x);
            
          
        end
    end
    
    %Calculate Centroid in x and y dimensions
    centroid_array(frameIndex,1) = WeightedMass_X/SumOfMasses;
    centroid_array(frameIndex,2) = WeightedMass_Y/SumOfMasses;
    
end
            
    
    
    
    