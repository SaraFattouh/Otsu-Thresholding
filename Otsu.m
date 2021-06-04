 clc, 
 close('all');

Img = imread('motor.tif');
[rows,cols,dims] = size(Img);

if dims == 3
    Img = rgb2gray(Img);
end

Img = double(Img);

% Convert image to 8 bits
Img = uint8(255 * (Img - min(Img(:))) / (max(Img(:)) - min(Img(:))));

% Display the original image
figure, imagesc(Img);title('Original Image'), colormap(gray);

% histogram;
[Freq,bins] = imhist(Img);

% Compute global mean
mg = mean(Img(:));
hold on, line([mg mg],[0 max(Freq)],'Color',[1 0 0]);

%threshold value between k = 0 and 255
variance = zeros(1,256);
Goodness = variance;
NormalizedFreq = Freq / (rows * cols);

SigmaGlobal = var(double(Img(:)));


for k = 1:255-1
    P1 = sum(NormalizedFreq(1:k+1));
    mk = sum((NormalizedFreq(1:k+1) .* (0:k)')); 
    variance(k+1) = (mg * P1 - mk)^2 / (P1 * (1 - P1));
    Goodness(k+1) = variance(k+1) / SigmaGlobal;
end


[~,index]= max(variance);

string = sprintf('Image Thresholded  k = %d ',index);
figure,imagesc(Img>index);title(string);axis off, axis image,colormap(gray);

