% average RGB

function F=averageRGB(img)

% Compute the average red value of the image
red=img(:,:,1);
red=reshape(red,1,[]);
average_red=mean(red);

% Compute the average green value of the image
green=img(:,:,2);
green=reshape(green,1,[]);
average_green=mean(green);

% Compute the average blue value of the image
blue=img(:,:,3);
blue=reshape(blue,1,[]);
average_blue=mean(blue);

% Concatenate these three values to form a feature vector F
F=[average_red average_green average_blue];

return;