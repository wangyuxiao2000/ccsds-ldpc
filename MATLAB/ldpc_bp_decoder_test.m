%*************************************************************%
% function: CCSDS-QC-LDPC 概率域BP解码测试用例
% Author  : WangYuxiao
% Email   : wyxee2000@163.com
% Data    : 2023.1.3
% Version : V 1.0
%*************************************************************%
% 初始化
clear; 
close all;
clc;

% 设定参数
stander = "8160_7136"; % 设定码长,对于近地应用可选"8176_7154"、"8160_7136"
block_num = 10;        % 设定仿真码块数
Eb_N0_request = 5;     % 设定仿真信噪比
iteratio_max = 10;     % 设定解码最大迭代次数

% 提取当前码字的(n, k)参数
splitStr = split(stander, "_");
n = str2double(splitStr{1});
k = str2double(splitStr{2});

% 产生用户数据
usr_data = m_sequence([1 0 0 0 0 0 0 0 0 0], [1 0 0 0 0 0 0 1 0 0 1], k*block_num);

% 进行编码
[~, G_sub_matrix, sub_matrix_size, encoder_result] = ldpc_encoder(stander, usr_data);

% 进行电平映射(0对应+1,1对应-1)并加入高斯白噪声
tx_data = reshape(encoder_result.', 1, []);
xi = ones(1,length(tx_data));
xi(tx_data == 1) = -1;
[rx_simple, Eb_N0_real, sigma2] = ldpc_noise_adder(xi, Eb_N0_request);

% 进行BP译码并计算误码率
[result_message, result_full, right_flag] = ldpc_bp_decoder(stander, rx_simple, sigma2, iteratio_max);
BER = nnz(reshape(result_message.', 1, []) ~= usr_data)/numel(usr_data);