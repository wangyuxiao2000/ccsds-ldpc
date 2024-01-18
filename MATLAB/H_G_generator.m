%*************************************************************%
% function: CCSDS-LDPC H/G矩阵生成
% Author  : WangYuxiao
% Email   : wyxee2000@163.com
% Data    : 2024.1.3
% Version : V 1.0
%*************************************************************%
function [H, G_sub_matrix, sub_matrix_size] = H_G_generator(stander)
    
    if (stander == "8176_7154" || stander == "8160_7136")
        % 定义H矩阵及G矩阵(CCSDS 131.1-O-1)
        G_path = "NEAR_EARTH_G.txt";
        H_path = "NEAR_EARTH_H.txt";
        sub_matrix_size = [511 511];
        
        % 生成H矩阵
        H_stander = load(H_path);
        H = zeros(1022, 8176);
        H_cell = cell(1,size(H_stander, 1));
        for sub_num = 1:size(H_stander, 1)
            H_sub_matrix = zeros(sub_matrix_size(1), sub_matrix_size(2));
            H_one_position = H_stander(sub_num, :) + 1;
            H_sub_matrix(1,:) = full(sparse(ones(1, length(H_one_position)), H_one_position, 1, 1, sub_matrix_size(2)));
            for i = 2:sub_matrix_size(1)
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
        G_sub_matrix = cellfun(@(x) hexToBinaryVector(x, sub_matrix_size(1)+1), G_sub_matrix, 'UniformOutput', false);
        G_sub_matrix = cellfun(@(x) x(2:end), G_sub_matrix, 'UniformOutput', false);
    end

end