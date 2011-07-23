%
% ECE 4007 - Spring 2009
%
% acquire.m
% Main Function to acquire video stream from webcamera and take a snapshot
% of last viewed frame.
% Author: Akshay Patel
% Date: April 1, 2009

% For some reason, once a person is detected in the frame, they continue
% to be detected, correctly or not.

% Define a video object and associate it with the floor camera.
floor = videoinput('winvideo',1,'RGB24_320x240');
% Define a video object and associate it with the bed camera.
bed = videoinput('winvideo',2,'RGB24_320x240');

floor_src = getselectedsource(floor);
floor_src.FrameRate = '10.0000';
bed_src = getselectedsource(bed);
bed_src.FrameRate = '10.0000';

% Sets video object to obtain frames ONLY upon "trigger" command.
triggerconfig(floor, 'manual');
triggerconfig(bed, 'manual');

% Sets video object to obtain ONE frame upon "trigger" command.
set(floor,'FramesPerTrigger', 1);
set(bed, 'FramesPerTrigger', 1);

% Sets maximum number of times "trigger" command can be called.
set(floor,'TriggerRepeat', Inf);
set(bed, 'TriggerRepeat', Inf);

% Starting Input Stream
disp('Starting Image Capture...');

% Capture initial reference images for floor and bed.
start(floor);
start(bed);
trigger(floor);
trigger(bed);
floorFrames{1} = rgb2gray(getdata(floor,1));
bedFrames{1} = rgb2gray(getdata(bed,1));

% Show initial reference images
figure, subplot(1,2,1), imshow(floorFrames{1}), subplot(1,2,2), imshow(bedFrames{1});

floorFG{1} = floorFrames{1}; % Initialize the differenced floor image
bedFG{1} = bedFrames{1}; % Initialize the differenced bed image

[y_max x_max] = size(floorFrames{1});

% Somewhat arbitrary threshold value that will need tweaking...
T = 10;
sum = 0;

% Time elapsed, in seconds
time = 0;

while(1)
    
    % Throw out next nine floor and bed frames
    for q=1:9
        trigger(floor);
        floorFrames{2} = rgb2gray(getdata(floor,1));
        trigger(bed);
        bedFrames{2} = rgb2gray(getdata(bed,1));
    end
    % Acquire the tenth floor and bed frames
    trigger(floor);
    floorFrames{2} = rgb2gray(getdata(floor,1));
    trigger(bed);
    bedFrames{2} = rgb2gray(getdata(bed,1));
    
    % Form difference images
    for y=1:y_max
        for x=1:x_max
            %if(sum < abs(floorFrames{2}(y,x) - floorFrames{1}(y,x)))
                %sum = abs(floorFrames{2}(y,x) - floorFrames{1}(y,x));
            %end
            if(abs(floorFrames{2}(y,x) - floorFrames{1}(y,x)) > T)
                floorFG{1}(y,x) = 255;
            else
                floorFG{1}(y,x) = 0;
            end
            if(abs(bedFrames{2}(y,x) - bedFrames{1}(y,x)) > T)
                bedFG{1}(y,x) = 255;
            else
                bedFG{1}(y,x) = 0;
            end
        end
    end
    
    % BLOB DETECTION %
    
    % Compute the labeled frames
    M = bwlabel(floorFG{1}, 4);
    N = bwlabel(bedFG{1}, 4);
    
    % Compute the number of blobs
    floorBlobs = max(max(M));
    bedBlobs = max(max(N));
    
    % Define the largest object values, floorNum and bedNum
    floorNum = 0;
    floorCount = 0;
    bedNum = 0;
    bedCount = 0;
    
    for q = 1:floorBlobs
        currentCount = size(find(M==q));
        if(currentCount(1) > floorCount)
            floorCount = currentCount(1);
            floorNum = q;
        end
    end
    
    for q = 1:bedBlobs
        currentCount = size(find(N==q));
        if(currentCount(1) > bedCount)
            bedCount = currentCount(1);
            bedNum = q;
        end
    end
    
    % This step is not even necessary...for display purposes only.
    if(floorNum > 0 && floorCount > 4000) % floorCount > 4000 to disregard little blobs
        for y = 1:y_max
            for x = 1:x_max
                if M(y,x) == floorNum
                    floorFG{1}(y,x) = 255;
                else
                    floorFG{1}(y,x) = 0;
                end
            end
        end
    else
        floorFG{1}(:,:) = 0;
    end
    
    if(bedNum > 0 && bedCount > 4000) % bedCount > 4000 to disregard little blobs
        for y = 1:y_max
            for x = 1:x_max
                if N(y,x) == bedNum
                    bedFG{1}(y,x) = 255;
                else
                    bedFG{1}(y,x) = 0;
                end
            end
        end
    else
        bedFG{1}(:,:) = 0;
    end
    
    if(floorNum > 0 && floorCount > 4000)
        % This means a person is in the FLOOR REGION
        disp('Person detected in floor region at t= ');
        disp(time);
    else
        % This means a person is NOT in the FLOOR REGION
        % Therefore, this becomes the new reference shot
        floorFrames{1} = floorFrames{2};
    end
    
    if(bedNum > 0 && bedCount > 4000)
        % This means a person is in the BED REGION
        disp('Person detected in bed region at t= ');
        disp(time);
    else
        % This means a person is NOT in the BED REGION
        % Therefore, this becomes the new reference shot
        bedFrames{1} = bedFrames{2};
    end
    
    time = time + 1;
    figure, subplot(2,2,1), imshow(floorFrames{2}), subplot(2,2,2), imshow(floorFG{1})
    subplot(2,2,3), imshow(bedFrames{2}), subplot(2,2,4), imshow(bedFG{1});
    
    if(time > 5)
        stop(floor);
        stop(bed);
        break;
    end
end

% figure, imshow(floorFrames{1}), figure, imshow(floorFrames{2}), figure, imshow(floorFG{1});
% stop(floor);

