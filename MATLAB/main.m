%*************************************************************%
% function: LDPC 误码曲线仿真
% Author  : WangYuxiao
% Email   : wyxee2000@163.com
% Data    : 2024.1.26
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
Eb_N0_request_min = 2;       % Eb_N0最小值(dB)
Eb_N0_request_max = 2.8;     % Eb_N0最大值(dB)
Eb_N0_request_step = 0.2;    % Eb_N0步进值(dB)
block_num = 500;             % 每个信噪比下仿真码块的个数
iteratio_max = 20;           % 最大迭代次数
method = "UMP BP";           % 设定解码算法,可选"BP"/"LLR BP"/"UMP BP"

% 提取当前码字的(n, k)参数
splitStr = split(stander, "_");
n = str2double(splitStr{1});
k = str2double(splitStr{2});
    
% 生成H矩阵和G矩阵(CCSDS 131.1-O-1)
[H, H_simplify, sub_matrix_size_H, G, G_simplify, sub_matrix_size_G] = H_G_generator(stander);

% 进行LDPC编码及BPSK电平映射
usr_data = m_sequence([1 0 0 0 0 0 0 0 0 0], [1 0 0 0 0 0 0 1 0 0 1], k*block_num);
encoder_result = ldpc_encoder(stander, usr_data);
tx_data = reshape(encoder_result.', 1, []);
xi = ones(1,length(tx_data));
xi(tx_data == 1) = -1;

% 进行误码曲线仿真
Eb_N0_request = Eb_N0_request_min:Eb_N0_request_step:Eb_N0_request_max; % 仿真设定信噪比
Eb_N0_real = zeros(1, length(Eb_N0_request));                           % 实际信噪比
ber = zeros(length(iteratio_max), length(Eb_N0_request));               % 各信噪比及迭代次数对应的误码率

for Eb_N0_cnt = 1:length(Eb_N0_request)   
    % 加入高斯白噪声
    [rx_simple, Eb_N0_real(Eb_N0_cnt), sigma2] = ldpc_noise_adder(xi, Eb_N0_request(Eb_N0_cnt), n, k);
    
    % 在不同的最大迭代次数下进行译码并计算误码率
    for iteratio_max_cnt = 1:length(iteratio_max)
        [result, ~, right_flag] = ldpc_decoder(stander, rx_simple, sigma2, iteratio_max(iteratio_max_cnt), method); 
        ber(iteratio_max_cnt, Eb_N0_cnt) = nnz(reshape(result.', 1, []) ~= usr_data)/numel(usr_data);
    end
end

% 绘制误码率曲线
figure;
semilogy(Eb_N0_real, ber(1, :), '*r-');
grid on;
xlabel("Eb/N0 (dB)");
ylabel("BER");
legend("iteratio max=20");
title("UMP-BP BER for (2048,1024)");

clearvars -except H H_simplify sub_matrix_size_H G G_simplify sub_matrix_size_G Eb_N0_request Eb_N0_real ber;