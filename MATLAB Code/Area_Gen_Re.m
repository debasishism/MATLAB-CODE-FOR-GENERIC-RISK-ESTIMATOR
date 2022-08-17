
warning('off','all')
warning
clear all;
close all;
clc;
tic;
m=0;
sigma=6425;
L=3;
im= rgb2gray(imread('3_patch_2k.png'));
im= im2double(im);
im= uint16(round(im*65535));
arialclean= imresize(im,[512 512]);
% imn= imnoise(im,'gaussian',0,0.01);
clean=double(im);
clean=imresize(clean,[512 512]);
[r,c]=size(clean);
w=sigma*randn(r,c); %noise
% w=0;
noisy=clean;
ntrans=noisy';

a=512;

LH_d = zeros(a,a, L);
HL_d = zeros(a,a, L);
HH_d = zeros(a,a, L);
LL_d = zeros(a,a, L);
LH_r = zeros(a,a, L);
HL_r = zeros(a,a, L);
HH_r = zeros(a,a, L);
LL_r = zeros(a,a, L);

for i = 1: L
    
    [LH_d(:, :, i), HL_d(:, :, i), HH_d(:, :, i), LL_d(:, :, i)] = decompose(noisy, i);
    LH = LH_d(:, :, i);
    HL = HL_d(:, :, i);
    HH = HH_d(:, :, i);

end;


phi = zeros(a*a,3*L+1);
for i = 1: L
    [LH_r(:, :, i), HL_r(:, :, i), HH_r(:, :, i), LL_r(:, :, i)] = recompose(LH_d(:, :, i), ...
        HL_d(:, :, i), HH_d(:, :, i), LL_d(:, :, i), i);
    x1 = LH_r(:, :, i)';
    phi(:, 3*i-2) = x1(:);
    
    x2 = HL_r(:, :, i)';
    phi(:, 3*i-1) = x2(:);
    
    x3 = HH_r(:, :, i)';
    phi(:, 3*i) = x3(:);
    h(3*i - 2 : 3*i) = 1/2^(2*i);
end;
h(3*L+1) = 1/2^(2*L);
x = LL_r(:, :, L)';
phi(:, 3*L+1) = x(:);
F = phi;


% Full precision
[denoised_O, a] = Gen_RE(F, ntrans, sigma, h);


figure(1);
imshow(clean,[]);
figure(2);
imshow(noisy, []);
figure;
imshow(denoised_O,[]);
title(['GenRE algorithm L =',num2str(L)]);
%-------performace ------

psnr1 = peak_signal_to_noise_ratio_wavelet(arialclean,noisy);
psnr2 = peak_signal_to_noise_ratio_wavelet(arialclean,denoised_O);

ssim1 = cal_ssim(arialclean,noisy);
ssim2 = cal_ssim(arialclean,denoised_O);
fprintf('The SSIM value of the noisy image is %0.4f\n',ssim1);
fprintf('The SSIM value of the denoised image is %0.4f\n',ssim2);
toc;
MSE_N_Rslt  = mean((noisy(:)- clean(:)).^2);
PSNR_N = 10*log10(255^2/MSE_N_Rslt);
MSE_F_Rslt  = mean((denoised_O(:)- clean(:)).^2);
PSNR_F = 10*log10(255^2/MSE_F_Rslt);
Gain = PSNR_F - PSNR_N;
SSIM_N = ssim_index(clean,noisy);
SSIM_F = ssim_index(clean,denoised_O);



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Save PSNR
Sep  = '%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%\n';
PN   = 'PSNR_Noisy = %2.3f dB\n';
PRef = 'PSNR_Ref   = %2.3f dB;      PSNR Gain = %2.3f\n';


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Save SSIM
Sep  = '%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%\n';
PN   = 'SSIM_Noisy = %2.4f dB\n';
PRef = 'SSIM_Ref   = %2.4f dB\n';

