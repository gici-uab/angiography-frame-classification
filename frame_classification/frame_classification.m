%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Copyright (c) 2014, Zhongwei Xu
% All rights reserved.
% 
% Redistribution and use in source and binary forms, with or without
% modification, are permitted provided that the following conditions are
% met:
% 
%     * Redistributions of source code must retain the above copyright
%       notice, this list of conditions and the following disclaimer.
%     * Redistributions in binary form must reproduce the above copyright
%       notice, this list of conditions and the following disclaimer in
%       the documentation and/or other materials provided with the distribution
% 
% THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
% AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
% IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
% ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
% LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
% CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
% SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
% INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
% CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
% ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
% POSSIBILITY OF SUCH DAMAGE.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function ln1 = frame_classification(ima_after_frangi, ln)
% FRAME_CLASSIFICATION(IMA_AFTER_FRANGI, LN), returns a value LN1 representing the number of frames of the preperfusion phase in the coronary angiogram.
%
%   IMA_AFTER_FRANGI.  A string of the image's filename. This image is the enhanced image got from the result of function SOLO_FRANGI. If the image is not in the current folder, or in a folder on the MATLAB® path,
%   specify the full pathname. 
%
%   LN.  A scalar that tells the number of total frames in the image.
%
%   Examples for usage, see the demo.m
%
%   Function is written by Z.Xu Universitat Autonoma de Barcelona (Dec. 2014)


fid = fopen(ima_after_frangi,'r');
GY = fread(fid, 512*512*ln, 'single');
m = reshape(GY,512,512,ln);

sum_frame = zeros(ln,1);

element_increase = zeros(ln,1);

for i=1:ln
    
    sum_frame(i) = sum(sum(m(:,:,i)));
    
end

% sum_frame = medfilt1(sum_frame,5);

used_plot = sum_frame;
figure; 
plot(used_plot);
title('Graph of intensity sum in each frames');
xlabel('Frame Index');
ylabel('Pixels Intensity sum');

win = round(ln/15);

pad_sum_frame = padarray(used_plot, [win,0],'replicate','post');

for i = 1:ln

   [element_max,position] = max(pad_sum_frame(i:i+win));
   
   element_min = min(pad_sum_frame(i:i+position-1));
   
   element_increase(i) = element_max - element_min; 
    
end

T = 0.8*max(element_increase);                                              % Set the threshold value

for i = 1:ln
   
    if element_increase(i) > T
        
        [e2,p2] = max(element_increase(i:i+round(win/2)-1));
        ln1 = i+p2-1;
        break;
        
    end
    
end

%close all

fprintf('The frame number of pre-perfusion phase: %d \n', ln1)

end










