%
% ECE 4007 - Spring 2009
%
% OrientEccent.m
% To determine the orientation (angle theta) and eccentricity
% (parameter rho) for the ellipse from each frame.
% 
% INPUT: Image cell array of dimensinos 1xNumOfFrames, where each cell is a
% matrix of dimensions MxN that represents one frame of the video.
% Additionally, the NumOfFramesx2 matrix centroid, where row N is the x and
% y coordinate of the centroid of the elliipse in frame N.
% 
% OUTPUT: Two NumOfFramesx1 vectors named thetas and rhos, where thetas(N)
% and rhos(N) are the angle and eccentricity of the ellipse in the Nth
% frame.
% Author: Abhishek Chandrashekhar
% Date: February 23, 2009

function [thetas rhos] = OrientEccent(fg,centroids)

%Define Number of Frames
NumOfFrames = length(fg);

%Define the output, thetas and rhos
thetas = zeros(NumOfFrames,1);
rhos = zeros(NumOfFrames,1);

%Start global loop for each frame
for frameIndex = 1:NumOfFrames
    
    %Load current frame from image cell
    frame = fg{frameIndex};
     
    %Get dimensions of the frame
    [y_max x_max] = size(frame);
    
    %Extract xbar and ybar from centroids array
    xbar = centroids(frameIndex,1);
    ybar = centroids(frameIndex,2);
    
    %Define each moment to be calculated
    m11 = 0;
    m20 = 0;
    m02 = 0;
    
    %Begin looping through each point
    for y = 1:y_max
        for x = 1:x_max
            
            m11 = m11 + ( (x-xbar)* (y-ybar)*frame(y,x) );
            m20 = m20 + ( (x-xbar)^2 * frame(y,x) );
            m02 = m02 + ( (y-ybar)^2 * frame(y,x) );
        end
    end
    
    thetas(frameIndex) = .5*atan( (2*m11)/(m20 - m02) );
    imin = .5*(m20 + m02 - sqrt( (m20-m02)^2 + 4*m11^2 ) );
    imax = .5*(m20 + m02 + sqrt( (m20-m02)^2 + 4*m11^2 ) );
    rhos(frameIndex) = sqrt(imax/imin);
    
end
    