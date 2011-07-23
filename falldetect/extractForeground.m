%
% ECE 4007 - Spring 2009
%
% extractForeground.m
% Extracts foreground from the input video.The output of the function is
% data of silhouette images of the input video
%
% video:  The only required input parameter.It is required to extract cdata.
% 
% significanceThreshold:  This is the threshold in which the pixel is either labeled as a foreground 
%                         or background.It can be changed to analyze different videos
%                         The default value is set to 15
%
% frameSkip: Larger video files would need to skip certain frames for quick calculation of the background model.  if this is
%            If the value is not provided, a default value of every 4th frame will be used.  
%
% returnLargestComponent:  this is a feature that can return only the
%                          largest component of the foreground. It can be used if there is a lot of noise.
%                          Default value is at 0. If this value is changed
%                          parts of the foreground model can be left behind
%
% Code Excerpts from a project by Benson Huang
%
% Author: Akshay Patel
% Date: April 1, 2009

function foreground = extractForeground(video, significanceThreshold, frameSkip, returnLargestComponent)

% Apply default values if required

if (nargin < 2)||isempty(significanceThreshold),     significanceThreshold = 16;                 end;
if (nargin < 3)||isempty(frameSkip),                 frameSkip = 4;                              end;
if (nargin < 4)||isempty(returnLargestComponent),    returnLargestComponent = 0;                 end;
disp('File processed...');
clear frames


if ischar(video)
    % Load the video from an avi file.
    avi = aviread(video);
    pixels = double(cat(4,avi(1:frameSkip:end).cdata))/255;
    % Remove from memory
    clear avi
else
    % Compile the pixel data into a single array
    
    pixels = double(cat(4,video{1:frameSkip:end}))/255;
end;

disp('Packing Pixels Completed..');

% Convert to HSV color space

nFrames = size(pixels,4);
for f = 1:nFrames
    pixels(:,:,:,f) = rgb2hsv(pixels(:,:,:,f));
end;
% Generate Gaussian background model in HSV space for each pixel

% The Data range can be modified for faster calculation

dataRange = [.45 .55]; 
[backgroundMean, backgroundDeviation] = hsvGaussModel(pixels,dataRange);

disp('Gaussian Generated!');

model = backgroundMean;

% Begin frame-by-frame differencing

foreground = cell(1,nFrames);

for f = 1:length(video)
    % Find scaled deviation of this frame from background
    
    deviation = sum(abs(rgb2hsv(double(video{f})/255) - backgroundMean), 3) * 85;
     
    % Compare with threshold to generate labeling before applying morphological operations
    
    label = double(imopen(imclose(deviation > significanceThreshold, strel('square',1)), strel('disk',2)));

    % clean up:  find largest connected component
    
    if returnLargestComponent
        label = fgRanked(label,1);
    end;
    foreground{f} = label;   
    clear temp
end;

% Function from Mathworks
%--------------------------------------------------------------------
% Fits a gaussian to the specified distribution, in a robust manner.
%
% Returns the mean and standard deviation of the input arguments
% using the specified portion of the data.  Uses HSV color space
% for better shadow control.

function [mu,sigma] = hsvGaussModel(pixels,dataRange)

% Statistics of s & v dimensions are simple.
[mu(:,:,2:3),sigma(:,:,2:3)] = fitGauss(pixels(:,:,2:3,:),dataRange,4);
hmu = polarMean(pixels(:,:,1,:)*2*pi,4);
h = zeros(size(pixels(:,:,1,:)));
nFrames = size(pixels,4);
for i = 1:nFrames
    h(:,:,1,i) = mod(pixels(:,:,1,i)*2*pi-hmu+pi,2*pi);
end;
[mu(:,:,1),sigma(:,:,1)] = fitGauss(h,dataRange,4);
mu(:,:,1) = mod(mu(:,:,1)-pi+hmu,2*pi)/(2*pi);
sigma(:,:,1) = sigma(:,:,1)/(2*pi);

% Mathworks
%--------------------------------------------------------------------
% Fits a gaussian to the specified distribution, in a robust manner.
%
% Returns the mean and standard deviation of the input arguments
% using the specified portion of the data

function [mu,sigma] = fitGauss(m,dataRange,dim)
x = -3:0.01:3;
y = exp(-x.^2);
y = y./sum(y);
yy = cumsum(y);
fdev = sqrt(sum(y.*x.^2));
xbd = min(find(yy > dataRange(1))):min(find(yy > dataRange(2)));
pdev = sqrt(sum(y(xbd).*x(xbd).^2)/sum(y(xbd)));

dimlen = size(m,dim);
if all(dataRange == [0 1])|(dim > length(size(m)))
    % skip sorting step if we'll be using everything anyway
    ms = m;
else
    ms = sort(m,dim);
end;
dimind = round(dataRange*(dimlen-1)+1);
[refstr{1:length(size(m))}] = deal(':');
if (dim <= length(size(m)))
    refstr{dim} = dimind;
end;
sref = struct('type','()','subs',{refstr});
bds = subsref(ms,sref);
if (dim <= length(size(m)))
    sref.subs{dim} = dimind(1):dimind(2);
end;
data = subsref(ms,sref);
mu = mean(data,dim);
sigma = std(data,0,dim)*fdev/pdev;

%--------------------------------------------------------------------
% Returns the "mean" of a set of angular variables

function pm = polarMean(th,dim)
th = mod(th,2*pi);
x = cos(th);
y = sin(th);
if (nargin < 2)
    pm = mod(atan2(mean(y),mean(x)),2*pi);
else
    pm = mod(atan2(mean(y,dim),mean(x,dim)),2*pi);
end;
% end of polarMean


%--------------------------------------------------------------------
% Returns the foreground connected component in the binary image
% supplied that have the specified ranked size(s).

function fgr = fgRanked(bin,rank)
fg = bwlabel(bin,4);
maxfg = max(fg(:));
h = hist(fg(find(bin)),[1:maxfg]);
[sh,sr] = sort(-h);
if (rank < 1)|(rank > max(find(sh > 0)))
    fgr = zeros(size(img))
else
    fgr = (fg==sr(rank));
end;
%--------------------------------------------------------------------

