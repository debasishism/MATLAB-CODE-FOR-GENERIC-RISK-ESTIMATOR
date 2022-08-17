function [LH_d, HL_d, HH_d, LL_d] = recompose (LH, HL, HH, LL, Lev)
h_L = ones(2^Lev, 1);
h_H = [ones(2^(Lev- 1), 1); -ones(2^(Lev- 1), 1)];
h_LH = h_H*h_L';
h_HL = h_L*h_H';
h_HH = h_H*h_H';
h_LL = h_L*h_L';

Len_Fil = 2^Lev;
LH_d = 1/Len_Fil^2 * filtr(LH, h_LH, Lev);
HL_d = 1/Len_Fil^2 * filtr(HL, h_HL, Lev);
HH_d = 1/Len_Fil^2 * filtr(HH, h_HH, Lev);
LL_d = 1/Len_Fil^2 * filtr(LL, h_LL, Lev);

