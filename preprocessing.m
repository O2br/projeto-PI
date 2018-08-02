function [found] = preprocessing(foto)
  
foto = imadjust(foto);

figure, imshow(foto);

redplane = foto(:, :, 1);
greenplane = foto(:, :, 2);
blueplane = foto(:, :, 3);

% destaca objetos vermelhos (exemplo desse site: https://www.mathworks.com/examples/matlab/community/32661-find-green-object)
justRed = redplane - greenplane/2 - blueplane/2;

%figure, imshow(justRed);
if graythresh(justRed) > 0.15
  justRed = im2bw(justRed, graythresh(justRed));
else
  justRed = im2bw(justRed, 0.15);
endif

%% faz fechamento para tentar deixar apenas os objetos vermelhos
%% remove ruidos que sao menores que a 1% da imagem
ruido = round(rows(foto)*columns(foto)*0.002);
justRed = bwareaopen(justRed, ruido);
justRed = imfill(justRed, 'holes');
justRed = imclose(justRed, strel("disk", 4, 0));

found = justRed;

end