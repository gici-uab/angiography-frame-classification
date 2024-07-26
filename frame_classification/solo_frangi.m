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

function solo_frangi(ima,ln,file_name)
% SOLO_FRANGI(IMA, LN, file_name), returns a raw image which is frangi enhanced. 
%   It applies the frangi filter, where the frangi filter function is realized using the source code from Dirk-Jan Kroon (2010) 
%   (see http://www.mathworks.com/matlabcentral/fileexchange/24409-hessian-based-frangi-vesselness-filter). Files for frangi filter funciton are included in ./frangi_filter_version2a/ 
%
%   IMA.  A string of the image's filename. If the image is not in the current folder, or in a folder on the MATLAB® path,
%   specify the full pathname. 
%
%   LN.  A scalar that tells the number of frames in the image.
%
%   FILE_NAME. A string of the image's filename, but without the file
%   extension and the folder path.
%   
%   Examples for usage, see the demo.m
%
%   Function is written by Z.Xu Universitat Autonoma de Barcelona (Dec. 2014)


fid = fopen(ima,'r');
GY = fread(fid, 512*512*ln, 'uint16');
m = reshape(GY,512,512,ln);

Ivessel_after_frangi = zeros(512,512,ln); 

options = struct('FrangiScaleRange', [1 10], 'FrangiScaleRatio', 0.1, 'FrangiBetaOne', 0.5, 'FrangiBetaTwo', 15, 'verbose', false, 'BlackWhite', true);

for i=1:ln

    m(:,:,i) = medfilt2(m(:,:,i),[5,5]);
    
    Ivessel = FrangiFilter2D(m(:,:,i), options);
    
    Ivessel_after_frangi(:,:,i) = Ivessel;
    
    fprintf('frame %d done frangi \n', i);
    
end

fid = fopen([file_name,'after_frangi.raw'],'w+');

fwrite(fid,Ivessel_after_frangi,'single');

fclose(fid);

close all

end
