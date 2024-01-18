%*************************************************************%
% function: CCSDS-QC-LDPC编码测试用例
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

% 提取当前码字的(n, k)参数
splitStr = split(stander, "_");
n = str2double(splitStr{1});
k = str2double(splitStr{2});

% 产生用户数据
usr_data = m_sequence([1 0 0 0 0 0 0 0 0 0], [1 0 0 0 0 0 0 1 0 0 1], k*block_num);

% 进行编码
[~, G_sub_matrix, sub_matrix_size, encoder_result] = ldpc_encoder(stander, usr_data);

% 将测试用例导出,作为RTL代码测试向量
stimulus_data = reshape(usr_data.', 1, []);
fid = fopen("../ccsds_ldpc_encoder/sources/TB/stimulus.txt",'w');
fprintf(fid,'%d\r\n', stimulus_data);
fclose(fid);

response_data = reshape(encoder_result.', 1, []);
fid = fopen("../ccsds_ldpc_encoder/sources/TB/response.txt",'w');
fprintf(fid,'%d\r\n', response_data);
fclose(fid);

clearvars -except usr_data G_sub_matrix sub_matrix_size encoder_result;