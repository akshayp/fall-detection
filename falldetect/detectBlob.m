%
% ECE 4007 - Spring 2009
%
% detectBlob.m
%
% Author: Nicholas Chan
% Date: February 16, 2009
%

function [K blobSize] = detectBlob(fg)

global STATE

% Initialize the output, the set of frames with only one contiguous object,
% K.
K = fg;

%Start global loop for each frame
for frameIndex = 1:length(fg)

   % Load current frame from image cell
   frame = fg{frameIndex};

   % Compute frame size
   [STATE.M STATE.N] = size(frame);

   % Compute the labeled frame
   M = bwlabel(frame, 4);

   % Compute the number of blobs
   numBlobs = max(max(M));

   % Define the largest object value, primaryNum.
   primaryNum = 0;
   maxCount = 0;

   for q = 1:numBlobs
       currentCount = size(find(M==q));
       if(currentCount(1) > maxCount)
           maxCount = currentCount(1);
           primaryNum = q;
       end
   end

   if(primaryNum > 0 && maxCount > 960) % Disregard little blobs
       for y = 1:STATE.M
           for x = 1:STATE.N
               if M(y,x) == primaryNum
                   K{frameIndex}(y,x) = 255;
               else
                   K{frameIndex}(y,x) = 0;
               end
           end
       end
       blobSize(frameIndex) = maxCount;
   else
       K{frameIndex}(:,:) = 0;
   end
end