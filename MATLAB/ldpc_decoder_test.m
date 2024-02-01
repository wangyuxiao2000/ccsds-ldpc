%*************************************************************%
% function: CCSDS-QC-LDPC BP解码测试用例
% Author  : WangYuxiao
% Email   : wyxee2000@163.com
% Data    : 2024.1.3
% Version : V 1.0
%*************************************************************%
% 初始化
clear; 
close all;
clc;

% 设定参数
stander = "2048_1024"; % 设定码长:
                       % 对于近地应用可选"8176_7154"、"8160_7136"
                       % 对于深空应用可选"1280_1024"、"1536_1024"、"2048_1024"
                       %                "5120_4096"、"6144_4096"、"8192_4096"
                       %                "20480_16384"、"24576_16384"、"32768_16384"
block_num = 10;        % 设定仿真码块数
Eb_N0_request = 3;     % 设定仿真信噪比
iteratio_max = 20;     % 设定解码最大迭代次数

% 提取当前码字的(n, k)参数
splitStr = split(stander, "_");
n = str2double(splitStr{1});
k = str2double(splitStr{2});

% 生成H矩阵及G矩阵
[H, G, G_simplify, sub_matrix_size] = H_G_generator(stander);

% 产生用户数据
usr_data = m_sequence([1 0 0 0 0 0 0 0 0 0], [1 0 0 0 0 0 0 1 0 0 1], k*block_num);

% 进行编码
encoder_result = ldpc_encoder(stander, usr_data);

% 进行BPSK电平映射(0对应+1,1对应-1)并加入高斯白噪声
tx_data = reshape(encoder_result.', 1, []);
xi = ones(1,length(tx_data));
xi(tx_data == 1) = -1;
[rx_simple, Eb_N0_real, sigma2] = ldpc_noise_adder(xi, Eb_N0_request, n, k);

rx_simple = 2*rx_simple/max(abs(rx_simple)); % 确保接收信号幅度位于[-2,2]之间

% 通过硬判决直接提取信息位
hard_bit = zeros(1, n*block_num);
hard_bit(rx_simple<0) = 1;
hard_bit = reshape(hard_bit, n, block_num).';
hard_bit = hard_bit(:, 1:k);
BER = nnz(reshape(hard_bit.', 1, []) ~= usr_data)/numel(usr_data);

% 进行BP译码并计算误码率
[result_message_bp, result_full_bp, right_flag_bp] = ldpc_decoder(stander, rx_simple, sigma2, iteratio_max, "BP");
[result_message_llr, result_full_llr, right_flag_llr] = ldpc_decoder(stander, rx_simple, sigma2, iteratio_max, "LLR BP");
[result_message_ump, result_full_ump, right_flag_ump] = ldpc_decoder(stander, rx_simple, sigma2, iteratio_max, "UMP BP");
BER_bp = nnz(reshape(result_message_bp.', 1, []) ~= usr_data)/numel(usr_data);
BER_llr = nnz(reshape(result_message_llr.', 1, []) ~= usr_data)/numel(usr_data);
BER_ump = nnz(reshape(result_message_ump.', 1, []) ~= usr_data)/numel(usr_data);

isequal(BER_bp, BER_llr)