%
% ECE 4007 - Spring 2009
%
% DrawEllipse.m
% Draws an ellipse around detected blob in foreground
% Author: Abhishek Chandrashekhar
% Date: February 23, 2009

function fg_drawn = DrawEllipse(fg,centroids,thetas,rhos)

fg_drawn = fg;

NumOfFrames = length(fg);

t = 0:.01:2*pi;

for frameIndex = 1:NumOfFrames
    
    
    theta = thetas(frameIndex);
    
    %TO BE MODIFIED
    b = 60;
    a = b / rhos(frameIndex);
    
    h = centroids(frameIndex,1);
    k = centroids(frameIndex,2);
    
    x = h + cos(theta)*(a*cos(t)) - sin(theta)*(b*sin(t));
    y = k + sin(theta)*(a*cos(t)) + cos(theta)*(b*sin(t));
    
    for c = 1:length(x)
        fg_drawn{frameIndex}( round(y(c)) , round(x(c)) ) = .5;
    end
    
    fg_drawn{frameIndex}( round(centroids(frameIndex,2)) , round(centroids(frameIndex,1)) ) = .5;
    
end