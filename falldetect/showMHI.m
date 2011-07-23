%
% ECE 4007 - Spring 2009
%
% showMHI.m
% Input frame number and motion history vector to display normalized MHI
% at the specified frame.
% 
% Author: Nicholas Chan
% Date: April 1, 2009

function showMHI(n, motion_history)

frameDisp = motion_history{n};
frameDisp = double(frameDisp);
frameDisp = frameDisp ./ 15;
figure, imshow(frameDisp)
title('MHI Image');