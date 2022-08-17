function [x, a] = Gen_RE(F, noisy, sigma, h)
N = 512*512;
M = (F'*F);

Q = F'*noisy(:);
k = (sigma^2*N);
R = k*h'; 
C = Q - R;

a = M\C;
denoised_O  = reshape(F*a,512,512);
denoised_O = denoised_O';
x = round(denoised_O);