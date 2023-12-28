% 初始化
clear; 
close all;
clc;

% 设定仿真码块数
block_num = 10;

% 定义G矩阵(CCSDS 131.1-O-1)
G_path = "8160_7136_G.txt";
G_sub_matrix_size = [511 511];

% 生成G矩阵各子块的首行数据
fid = fopen(G_path, 'r');
G_sub_matrix = textscan(fid, '%s', 'Delimiter', '\n');
fclose(fid);
G_sub_matrix = G_sub_matrix{1};
G_sub_matrix = [G_sub_matrix(1:2:end), G_sub_matrix(2:2:end)];
G_sub_matrix = cellfun(@(x) hexToBinaryVector(x, 512), G_sub_matrix, 'UniformOutput', false);
G_sub_matrix = cellfun(@(x) x(2:end), G_sub_matrix, 'UniformOutput', false);

% 产生用户数据(每个码块包含7136bit的用户数据)
usr_data = m_sequence([1 0 0 0 0 0 0 0 0 0], [1 0 0 0 0 0 0 1 0 0 1], 7136*block_num);
usr_data = reshape(usr_data, 7136, block_num)';

% 进行虚拟填充(7136bit用户数据的首部添加18bit的0,得到一个LDPC码块编码所需的7154bit信息位)
ccsds_usr_data = [zeros(block_num, 18), usr_data];

% 进行(8176, 7154)LDPC编码
encoder_result = ldpc_encoder(ccsds_usr_data, 8176, 7154, G_sub_matrix, G_sub_matrix_size);
    
% 对每个LDPC码块编码得到的8176bit去除18bit虚拟填充,并在尾部添加2bit的0
ccsds_encoder_result = [encoder_result(:, 19:end), zeros(size(encoder_result, 1), 2)];

% 将测试用例导出,作为RTL代码测试向量
stimulus_data = reshape(usr_data.', 1, []);
fid = fopen("../ccsds_ldpc_encoder/sources/TB/stimulus.txt",'w');
fprintf(fid,'%d\r\n', stimulus_data);
fclose(fid);

response_data = reshape(ccsds_encoder_result.', 1, []);
fid = fopen("../ccsds_ldpc_encoder/sources/TB/response.txt",'w');
fprintf(fid,'%d\r\n', response_data);
fclose(fid);

clearvars -except usr_data G_sub_matrix ccsds_encoder_result;