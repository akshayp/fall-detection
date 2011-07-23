%
% ECE 4007 - Spring 2009
%
% FallDetect.m
% Main Function to run Fall Detection functions and plot relevant data.
% Author: Akshay Patel
% Date: April 1, 2009
%

clc
clear all
disp('Loading Video..');
% Fall Examples
 avi = aviread('Test Videos\Falls\Akshay Back Fall.avi');
% End of Fall Examples

% Non Fall Examples
% avi = aviread('Test Videos\Non-Falls\Akshay Bending Down, Sitting Down.avi');
% End of Non Fall Examples

frames = {avi.cdata};
disp('Extracting Foreground..');
fg = extractForeground(frames,30,4,0);
disp('Eliminating Noise from Foreground..');
fg_smooth=detectBlob(fg);
disp('Evaluating Motion History Image of the video..');
motion_history = MHI(fg_smooth);
disp('Determining Ellipse Statistical Properties..');
c = centroid(fg_smooth);
[thetas rhos] = OrientEccent(fg_smooth, c);
disp('Analyzing Statistics for Video..');
[sigma_t sigma_r c_motion] = statistics(thetas, rhos, motion_history);
subplot(2,2,1), plot(sigma_t),title('Theta Std Dev Values'), subplot(2,2,2), plot(sigma_r),title('Rho Std Dev Values'), subplot(2,2,3), plot(c_motion),title('C Motion Values');

maxTheta = max(sigma_t);
gaussianFilter = fspecial('gaussian', [9, 9], 3.8);

for t = 1:(length(sigma_t)-5)
    if(c_motion(t) > 0.65 && sigma_t(t) >= 0.9*maxTheta)
        disp('FALL DETECTED!!');
        figure, imshow(imfilter(frames{t+5}, gaussianFilter));
        break;
    end
end
disp('Done!!!');

%Code Used for Plotting the output as a grid.Check GUI.m for better usage.

%subplot(2,2,1);
%imshow(fg{22})
%title('Foreground Extraction');
%subplot(2,2,2);
%imshow(fg_smooth{22})
%title('Noise Elimination');
%subplot(2,2,3);
%imshow(fg_drawn{22})
%title('Ellipse Detection');
%subplot(2,2,4);
%T=15;
%frameDisp = motion_history{22};
%frameDisp = double(frameDisp);
%frameDisp = frameDisp ./ T;
%imshow(frameDisp)
%title('MHI Image');