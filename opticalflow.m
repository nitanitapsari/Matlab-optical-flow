clc;
clear all;

folder = 'D:\optical flow'; %letak videonya
file= dir(fullfile(folder, 'image*.jpg'));

for i=1:5
    f1 = fullfile(folder,file(i).name);
    f2 = fullfile(folder,file(i+1).name);
    fr1 = imread(f1);
    fr2 = imread(f2);

figure()
subplot 211
imshow(fr1);
im1 = im2double(rgb2gray(fr1));
subplot 212
imshow(fr2);
im2 = im2double(rgb2gray(fr2));

ww = 30; %bisa diganti sesuai yang diinginkan
w = round(ww/2);

sc = 2;
im2c = imresize(im2, 1/sc);
C1 = corner(im2c);
C1 = C1*sc;


k = 1;
for i = 1:size(C1,1)
    x_i = C1(i, 2);
    y_i = C1(i, 1);
    if x_i-w>=1 && y_i-w>=1 && x_i+w<=size(im1,1)-1 && y_i+w<=size(im1,2)-1
      C(k,:) = C1(i,:);
      k = k+1;
    end
end
% Plot gambar
figure()
imshow(fr2);
hold on
plot(C(:,1), C(:,2), 'r*')

Ix_m = conv2(im1,[-1 1; -1 1], 'valid'); 
Iy_m = conv2(im1, [-1 -1; 1 1], 'valid'); 
It_m = conv2(im1, ones(2), 'valid') + conv2(im2, -ones(2), 'valid'); 
u = zeros(length(C),1);
v = zeros(length(C),1);

for k = 1:length(C(:,2))
    i = C(k,2);
    j = C(k,1);
      Ix = Ix_m(i-w:i+w, j-w:j+w);
      Iy = Iy_m(i-w:i+w, j-w:j+w);
      It = It_m(i-w:i+w, j-w:j+w);

      Ix = Ix(:);
      Iy = Iy(:);
      b = -It(:);

      A = [Ix Iy];
      nu = pinv(A)*b;

      u(k)=nu(1);
      v(k)=nu(2);
end

figure()
imshow(fr2);
hold on
quiver(C(:,1), C(:,2), u,v, 1,'r')

end

a=u
b=v
Ix
Iy