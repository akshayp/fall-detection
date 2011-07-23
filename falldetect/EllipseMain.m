%
% ECE 4007 - Spring 2009
%
% EllipseMain.m
% Put together all the Ellipse Analysis functions. DrawEllipse has limited
% functionality on a multicore machine.
% Author: Abhishek Chandrashekhar
% Date: February 23, 2009

function [fg_drawn,thetas,rhos] = EllipseMain(fg)

centroids = centroid(fg);

[thetas rhos] = OrientEccent(fg,centroids);

fg_drawn = DrawEllipse(fg,centroids,thetas,rhos);