% 初始化
clear; 
close all;
clc;

% 定义H矩阵和G矩阵(CCSDS 131.1-O-1)
H_path = "8160_7136_H.txt";
G_path = "8160_7136_G.txt";
H_sub_matrix_size = [511 511];
G_sub_matrix_size = [511 511];

% 生成H矩阵
H_stander = load(H_path);
H = zeros(1022, 8176);
H_cell = cell(1,size(H_stander, 1));
for sub_num = 1:size(H_stander, 1)
    H_sub_matrix = zeros(H_sub_matrix_size(1), H_sub_matrix_size(2));
    H_one_position = H_stander(sub_num, :) + 1;
    H_sub_matrix(1,:) = full(sparse(ones(1, length(H_one_position)), H_one_position, 1, 1, H_sub_matrix_size(2)));
    for i = 2:H_sub_matrix_size(1)
        H_sub_matrix(i, :) = [H_sub_matrix(i-1, end), H_sub_matrix(i-1, 1:end-1)];
    end
    H_cell{sub_num} = H_sub_matrix;
end
H(1:511, :) = cell2mat(H_cell(1:16));
H(512:1022, :) = cell2mat(H_cell(17:32));

% 生成G矩阵各子块的首行数据
fid = fopen(G_path, 'r');
G_sub_matrix = textscan(fid, '%s', 'Delimiter', '\n');
fclose(fid);
G_sub_matrix = G_sub_matrix{1};
G_sub_matrix = [G_sub_matrix(1:2:end), G_sub_matrix(2:2:end)];
G_sub_matrix = cellfun(@(x) hexToBinaryVector(x, 512), G_sub_matrix, 'UniformOutput', false);
G_sub_matrix = cellfun(@(x) x(2:end), G_sub_matrix, 'UniformOutput', false);

% 进行误码曲线仿真
Eb_N0_request_min = 2.5;   % Eb_N0最小值(dB)
Eb_N0_request_max = 4;     % Eb_N0最大值(dB)
Eb_N0_request_step = 0.05; % Eb_N0步进值(dB)
block_num = 50;            % 每个信噪比下仿真码块的个数
iteratio_max = [10, 50];   % 最大迭代次数

Eb_N0_request = Eb_N0_request_min:Eb_N0_request_step:Eb_N0_request_max; % 仿真设定信噪比
Eb_N0_real = zeros(1,length(Eb_N0_request));                            % 实际信噪比
ber = zeros(length(iteratio_max),length(Eb_N0_request));                % 各信噪比及迭代次数对应的误码率

for Eb_N0_cnt = 1:length(Eb_N0_request)
    % 产生用户数据(每个码块包含7136bit的用户数据)
    usr_data = m_sequence([1 0 0 0 0 0 0 0 0 0], [1 0 0 0 0 0 0 1 0 0 1], 7136*block_num);
    usr_data = reshape(usr_data, 7136, block_num)';
    
    % 进行虚拟填充(7136bit用户数据的首部添加18bit的0,得到一个LDPC码块编码所需的7154bit信息位)
    ccsds_usr_data = [zeros(block_num, 18), usr_data];
    
    % 进行(8176, 7154)LDPC编码
    encoder_result = ldpc_encoder(ccsds_usr_data, 8176, 7154, G_sub_matrix, G_sub_matrix_size);
    
    % 对每个LDPC码块编码得到的8176bit去除18bit虚拟填充,并在尾部添加2bit的0
    ccsds_encoder_result = [encoder_result(:, 19:end), zeros(size(encoder_result, 1), 2)];
    
    % 进行电平映射(0对应+1,1对应-1)
    tx_data = reshape(ccsds_encoder_result.', 1, []);
    xi = ones(1,length(tx_data));
    xi(tx_data == 1) = -1;

    % 加入高斯白噪声
    [yi, Eb_N0_real(Eb_N0_cnt), sigma2] = ldpc_noise_adder(xi, Eb_N0_request(Eb_N0_cnt));
    
    % 接收端数据处理
    rx_data = reshape(yi, 8160, length(yi)/8160).';
    rx_data = [ones(size(rx_data, 1), 18), rx_data(:, 1:end-2)];

    % 在不同的最大迭代次数下,进行概率域BP译码并计算误码率
    for iteratio_max_cnt = 1:length(iteratio_max)
        [result, ~, right_flag] = ldpc_bp_decoder(rx_data, sigma2, H, iteratio_max(iteratio_max_cnt)); % 进行BP译码
        rx_usr_data = result(:, 19:end);
        ber(iteratio_max_cnt, Eb_N0_cnt) = nnz(rx_usr_data ~= usr_data)/numel(usr_data);
    end
end

% 绘制误码率曲线
figure;
plot(Eb_N0_real, ber(1, :), 'b-', 'LineWidth', 2, 'DisplayName', 'iteratio max = 10');
hold on;
plot(Eb_N0_real, ber(2, :), 'r--', 'LineWidth', 2, 'DisplayName', 'iteratio max = 50');
legend('show');
xlim([min(Eb_N0_real), max(Eb_N0_real)]);
xlabel('Eb/N0 (dB)');
ylabel('BER');
title('Bit Error Rate vs. Eb/N0');
grid on;
hold off;

clearvars -except H G_sub_matrix Eb_N0_request Eb_N0_real ber;