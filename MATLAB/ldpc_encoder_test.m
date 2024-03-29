%*************************************************************%
% function: CCSDS-QC-LDPC编码测试用例
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
stander = "1280_1024"; % 设定码长:
                       % 对于近地应用可选"8176_7154"、"8160_7136"
                       % 对于深空应用可选"1280_1024"、"1536_1024"、"2048_1024"
                       %                "5120_4096"、"6144_4096"、"8192_4096"
                       %                "20480_16384"、"24576_16384"、"32768_16384"
width = 8;             % RTL模块位宽:支持1、2、4、8、16、32、64
block_num = 10;        % 设定仿真码块数

% 提取当前码字的(n, k)参数
splitStr = split(stander, "_");
n = str2double(splitStr{1});
k = str2double(splitStr{2});

% 生成H矩阵及G矩阵
[H, H_simplify, sub_matrix_size_H, G, G_simplify, sub_matrix_size_G] = H_G_generator(stander);

% 将G矩阵导出为RTL代码所需的localparam参数
% G_simplify = cellfun(@(binaryVector) binaryVectorToHex(binaryVector), G_simplify, 'UniformOutput', false);
% fileID = fopen(sprintf('%s%s%s', "localparam_", stander, ".txt"), 'w');
% for i = 1:size(G_simplify, 1)
%     for j = 1:size(G_simplify, 2)
%         hex_value = G_simplify{i, j};
%         localparam_statement = sprintf('localparam G%d_%d = %d''h%s;\n', i, j, sub_matrix_size_G(2), hex_value);
%         fprintf(fileID, '%s', localparam_statement);
%     end
% end
% fclose(fileID);

% 产生用户数据
usr_data = m_sequence([1 0 0 0 0 0 0 0 0 0], [1 0 0 0 0 0 0 1 0 0 1], k*block_num);

% 进行编码
encoder_result = ldpc_encoder(stander, usr_data);

% 将测试用例导出,作为RTL代码测试向量
stimulus_data = reshape(usr_data.', 1, []);
stimulus_data = reshape(stimulus_data, width, []).';
fid = fopen("../ccsds_ldpc_encoder/sources/TB/stimulus.txt",'w');
for i = 1:size(stimulus_data, 1)
    fprintf(fid, '%d', stimulus_data(i, :));
    fprintf(fid, '\n');
end
fclose(fid);

response_data = reshape(encoder_result.', 1, []);
response_data = reshape(response_data, width, []).';
fid = fopen("../ccsds_ldpc_encoder/sources/TB/response.txt",'w');
for i = 1:size(response_data, 1)
    fprintf(fid, '%d', response_data(i, :));
    fprintf(fid, '\n');
end
fclose(fid);

clearvars -except usr_data encoder_result H H_simplify sub_matrix_size_H G G_simplify sub_matrix_size_G;