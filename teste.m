clear all, close all, clc;

[foto] = imread("placa-para.jpg");
template = imread("./Temp_placa/R_1.jpg");
figure, imshow(foto);

redplane = foto(:, :, 1);
greenplane = foto(:, :, 2);
blueplane = foto(:, :, 3);

% destaca objetos vermelhos (exemplo desse site: https://www.mathworks.com/examples/matlab/community/32661-find-green-object)
justRed = redplane - greenplane/2 - blueplane/2;

figure, imshow(justRed);
justRed = im2bw(justRed, 0.2);

%% faz abertura para tentar deixar apenas os objetos vermelhos
justRed = bwareaopen(justRed, 30);
justRed = imfill(justRed, 'holes');
justRed = imclose(justRed, strel("disk", 4, 0));
justRed = bwareaopen(justRed, 30);

%% recupera objetos que podem ser placas
conec = bwconncomp(justRed);
regioes = regionprops(conec, "basic");

figure, imshow(justRed);
for i = 1:rows(regioes)
  fronteira = regioes(i).BoundingBox;
  placa = im2bw(rgb2gray(foto));
  rectangle('Position', fronteira, 'EdgeColor', 'blue', 'LineWidth', 3);
  placa = imcrop(foto, round(fronteira));
  %figure, subplot(1,2,1), imshow(placa);
  template_resized = im2bw(rgb2gray(imresize(template, size(placa))));
  correlacao(i) = corr2(placa, template_resized);
  %subplot(1,2,2), imshow(template_resized), title(num2str(correlacao));
endfor

[maior_corr, melhor_regiao] = max(correlacao);
fronteira = regioes(melhor_regiao).BoundingBox;
figure, imshow(foto);
rectangle('Position', fronteira, 'EdgeColor', 'blue', 'LineWidth', 3);