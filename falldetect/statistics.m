%
% ECE 4007 - Spring 2009
%
% statistics.m
% The mother of all functions. Takes input from calculated characteristics 
% and stastically analyzes them to detect standard deviation and motion
% coefficient of the input video.
% Author: Nicholas Chan
% Date: February 16, 2009

function [sigma_t sigma_r c_motion] = statistics(thetas, rhos, mhi)

% This function will calculate standard deviation vectors for the
% orientation and eccentricity given as parameters. Time = 1s = 15 frames.

s = length(thetas);

if(isnan(thetas(1)) == 1)
    thetas(1) = 0;
end

if(isnan(rhos(1)) == 1)
    rhos(1) = 1;
end

for q = 2:s
    if isnan(thetas(q)) == 1
        thetas(q) = thetas(q-1);
    end
    if isnan(rhos(q)) == 1
        rhos(q) = rhos(q-1);
    end
end

for k = 15:s
    sigma_t(k-14) = std(thetas(k-14:k));
    sigma_r(k-14) = std(rhos(k-14:k));
end

numFrames = length(mhi);
c_motion = 0;
for frameIndex = 1:numFrames
    MHI = mhi{frameIndex};
    MHI_max = 15; %max(max(MHI));
    grayBin = zeros(15,1);
    numGray = 0;
    numWhite = 0;
    for q=1:120
        for k=1:160
            if MHI(q,k) == MHI_max
                numWhite = numWhite + 1;
            end
            if MHI(q,k) > 0 && MHI(q,k) < MHI_max
                grayBin(MHI(q,k)) = grayBin(MHI(q,k)) + 1;
                    %numGray = numGray + 1;
            end
        end
    end
    for q=1:14
        if grayBin(q) < 0.65*numWhite;
            numGray = numGray + grayBin(q);
        end
    end
    c_motion(frameIndex) = double(numGray)/(numWhite + numGray);
    if(isnan(c_motion(frameIndex)) == 1)
        c_motion(frameIndex) = 0;
    end
end
  
end
                    
        
        