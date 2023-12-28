% 初始化
clear; 
close all;
clc;

% 设置H矩阵
H = [0 1 0 1 1 1;
     1 0 1 0 1 1;
     1 1 1 1 0 0];

% 设置输入硬信息
yi = [0.8251, 1.1293, 0.7277, -1.2450, 1.3697, -1.5232];
sigma2 = 0.5;

% 进行比特翻转译码
[~, hard_bit_4, right_flag_4] = ldpc_bp_decoder(yi, sigma2, H, 4);
[~, hard_bit_7, right_flag_7] = ldpc_bp_decoder(yi, sigma2, H, 7);