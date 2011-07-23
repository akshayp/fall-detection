%
% ECE 4007 - Spring 2009
%
% acquire.m
% Main Function to acquire video stream from webcamera and take a snapshot
% of last viewed frame.
% Author: Akshay Patel
% Date: April 1, 2009


% Define a video object and associate it with the device.
vid = videoinput('winvideo',1,'RGB24_320x240');

src = getselectedsource(vid);
src.FrameRate = '10.0000';

% Sets video object to obtain frames ONLY upon "trigger" command.
triggerconfig(vid, 'manual');

% Sets video object to obtain ONE frame upon "trigger" command.
set(vid,'FramesPerTrigger', 1); 

% Sets maximum number of times "trigger" command can be called.
set(vid,'TriggerRepeat', Inf);

% Starting Input Stream
disp('Starting Input Stream');
% preview(vid);

% Capture reference image
start(vid);
trigger(vid);
f{1} = peekdata(vid,1);
frames{1} = getdata(vid,1);
FG{1} = rgb2gray(frames{1}); % Initalize the differenced image

figure, imshow(frames{1})

[y_max x_max] = size(frames{1});

% Somewhat arbitrary threshold value that will need tweaking...
T = 5;
sum = 0;

time = 0;

while(1)
    
    % Throw out next nine frames
    for q=1:9
        trigger(vid);
        frames{2} = getdata(vid,1);
    end
    trigger(vid);
    frames{2} = getdata(vid,1);
    
    % Form difference image
    for y=1:y_max
        for x=1:x_max
            red = abs(frames{2}(y,x,1) - frames{1}(y,x,1));
            green = abs(frames{2}(y,x,2) - frames{1}(y,x,2));
            blue = abs(frames{2}(y,x,3) - frames{1}(y,x,3));
            distance = sqrt(double(red)^2 + double(green)^2 + double(blue)^2);
            if(sum < distance)
                sum = distance;
            end
            if(distance > T)
                FG{1}(y,x) = 255;
            else
                FG{1}(y,x) = 0;
            end
        end
    end
    
    % BLOB DETECTION %
    
    % Compute the labeled frame
    M = bwlabel(FG{1}, 4);
    
    % Compute the number of blobs
    numBlobs = max(max(M));
    
    % Define the largest object value, primaryNum
    primaryNum = 0;
    maxCount = 0;
    
    for q = 1:numBlobs
        currentCount = size(find(M==q));
        if(currentCount(1) > maxCount)
            maxCount = currentCount(1);
            primaryNum = q;
        end
    end
    
    if(primaryNum > 0)% && maxCount > 100) % maxCount > X to disregard little blobs
        for y = 1:y_max
            for x = 1:x_max
                if M(y,x) == primaryNum
                    FG{1}(y,x) = 255;
                else
                    FG{1}(y,x) = 0;
                end
            end
        end
    else
        FG{1}(:,:) = 0;
    end
    
    time = time + 1;
    figure, subplot(1,2,1), imshow(frames{2}), subplot(1,2,2), imshow(FG{1});
    if(time > 5)
        stop(vid);
        break;
    end
end

% figure, imshow(frames{1}), figure, imshow(frames{2}), figure, imshow(FG{1});
% stop(vid);

