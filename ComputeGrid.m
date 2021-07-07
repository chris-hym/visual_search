function G=ComputeGrid(img,row,col)

% Read the image size
[imgrow imgcol imgdim]=size(img);

% Calculate the number of rows and columns for the given size of image grid
nrow=floor(imgrow/row);
ncol=floor(imgcol/col);

% Define an empty vector to store the grid information
gridinfo=[];

for i=1:row
    gridrow_begin=1+(i-1)*nrow;
    gridrow_end=i*nrow;
    for j=1:col
        gridcol_begin=1+(j-1)*ncol;
        gridcol_end=j*ncol;
        % Calculate average RGB value for the grid
        gridimg_red=img(gridrow_begin:gridrow_end,gridcol_begin:gridcol_end,1);
        gridimg_red=reshape(gridimg_red,1,[]);
        gridavg_red=mean(gridimg_red);
        gridimg_green=img(gridrow_begin:gridrow_end,gridcol_begin:gridcol_end,2);
        gridimg_green=reshape(gridimg_green,1,[]);
        gridavg_green=mean(gridimg_green);
        gridimg_blue=img(gridrow_begin:gridrow_end,gridcol_begin:gridcol_end,3);
        gridimg_blue=reshape(gridimg_blue,1,[]);
        gridavg_blue=mean(gridimg_blue);
        % Store the RGB value in the order of R,G and B
        gridinfo=[gridinfo gridavg_red gridavg_green gridavg_blue];
    end
end

G=gridinfo;

return;
        