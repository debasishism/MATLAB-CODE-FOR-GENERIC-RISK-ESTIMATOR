function [LH, HL, HH, LL] = decompose (Img, Lev)
h_L = ones(2^Lev, 1);
h_H = [-ones(2^(Lev- 1), 1); ones(2^(Lev- 1), 1)];
h_LH = h_H*h_L';
h_HL = h_L*h_H';
h_HH = h_H*h_H';
h_LL = h_L*h_L';
Len_Fil = 2^Lev;
Rows_In = size(Img, 1);
Cols_In = size(Img, 2);
Temp_Img = [Img(:, Cols_In - Len_Fil + 2 : Cols_In), Img];
Temp_Img = [Temp_Img(Rows_In - Len_Fil + 2 : Rows_In, :); Temp_Img];

LH = 1/Len_Fil^2 * conv2(Temp_Img, h_LH, 'valid');
HL = 1/Len_Fil^2 * conv2(Temp_Img, h_HL, 'valid');
HH = 1/Len_Fil^2 * conv2(Temp_Img, h_HH, 'valid');
LL = 1/Len_Fil^2 * conv2(Temp_Img, h_LL, 'valid');

