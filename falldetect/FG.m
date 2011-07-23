%
% ECE 4007 - Spring 2009
%
% FG.m
% Extract Foreground and nothing else from the input video file.
% Author: Akshay Patel
% Date: April 1, 2009
clc
disp('Begin Foreground Extraction!');
avi = aviread('test.avi');
frames = {avi.cdata}; 
fg = extractForeground(frames); 
disp('Done!!');
