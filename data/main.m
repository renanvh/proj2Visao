clear;
clc;

pkg load image

%carrega as imagens
img1 = imread('img1_patch.png');
img2 = imread('img2_patch.png');
img3 = imread('img2.png');

%tira o histograma de cada cor das 2 imagens_patch
img1red = imhist(img1(:,:,1));
img1green = imhist(img1(:,:,2));
img1blue = imhist(img1(:,:,3));

img2red = imhist(img2(:,:,1));
img2green = imhist(img2(:,:,2));
img2blue = imhist(img2(:,:,3));

%cria uma matriz de zeros para cada cor
Mred = zeros(256,1,'uint8');
Mgreen = zeros(256,1,'uint8');
Mblue = zeros(256,1,'uint8');

%calcula a função de distribuição cumulativa para cada cor
cdf1red = cumsum(img1red) / numel(img1);
cdf2red = cumsum(img2red) / numel(img2);

cdf1green = cumsum(img1green) / numel(img1);
cdf2green = cumsum(img2green) / numel(img2);

cdf1blue = cumsum(img1blue) / numel(img1);
cdf2blue = cumsum(img2blue) / numel(img2);

%calcula um mapeamento que transforme uma intensidade da primeira
% imagem de modo que ela esteja de acordo com a distribuição de
% intensidade da segunda imagem
for redidx = 1 : 256
    [~,redind] = min(abs(cdf2red(redidx) - cdf1red));%acha um valor aprox no vetor do histograma senao coloca o valor minimo
    Mred(redidx) = redind-1; %desconsidera o ultimo pq histograma da imagem vai de 0 a 255
end


for greenidx = 1 : 256
    [~,greenind] = min(abs(cdf2green(greenidx) - cdf1green));
    Mgreen(greenidx) = greenind-1;
end

for blueidx = 1 : 256
    [~,blueind] = min(abs(cdf2blue(blueidx) - cdf1blue));
    Mblue(blueidx) = blueind-1;
end

%Carrega cada cor na imagemfinal.
%Transforma em double pois img1 é do tipo uint8 e satura valores se você tentar ir além de 255
% para garantir que cheguemos a 256, devemos utilizar o tipo double. 
imgfinal(:,:,1) = Mred(double(img3(:,:,1))+1);
imgfinal(:,:,2) = Mgreen(double(img3(:,:,2))+1);
imgfinal(:,:,3) = Mblue(double(img3(:,:,3))+1);

%salva a imagem final
imwrite(imgfinal, "saida.png")

