%
% ECE 4007 - Spring 2009
%
% Gaussian_Smoothing_Kernel.m
%
% Author: Nicholas Chan
%
% Part of this function's code taken (with permission) from:
% http://www.bme.gatech.edu/groups/biml/teaching/BMED4783_Spring_2008/
%
% Date: February 13, 2009
%

function G = Gaussian_Smoothing_Kernel(w)

% Standard Deviation
s = w/5;

% Construct the Gaussian Kernel
i = 1:w;
m = (w+1)/2; 
G = exp( - ((i-m).^2) / (2*s*s) );
G = G' * G; % Thanks to separability
G = G / sum(sum(G));