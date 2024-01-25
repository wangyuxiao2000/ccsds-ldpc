%*************************************************************%
% function: CCSDS-LDPC H/G矩阵生成
% Author  : WangYuxiao
% Email   : wyxee2000@163.com
% Data    : 2024.1.3
% Version : V 1.0
%*************************************************************%
function [H, G, G_simplify, sub_matrix_size] = H_G_generator(stander)
    
    if (stander == "8176_7154" || stander == "8160_7136")
        % 定义H矩阵及G矩阵(CCSDS 131.1-O-1)
        G_path = "NEAR_EARTH_G.txt";
        H_path = "NEAR_EARTH_H.txt";
        sub_matrix_size = [511 511];
        
        % 生成完整的H矩阵
        H_stander = load(H_path);
        H = zeros(1022, 8176);
        H_cell = cell(1,32); % 每个cell是一个循环子矩阵
        for sub_num = 1:32
            H_sub_matrix = zeros(sub_matrix_size(1), sub_matrix_size(2));
            H_one_position = H_stander(sub_num, :) + 1; % 该子矩阵首行的1元素位置
            H_sub_matrix(1, H_one_position) = 1; % 该子矩阵的首行数据
            for i = 2:sub_matrix_size(1) % 由首行数据循环移位得到整个子矩阵
                H_sub_matrix(i, :) = [H_sub_matrix(i-1, end), H_sub_matrix(i-1, 1:end-1)];
            end
            H_cell{sub_num} = H_sub_matrix;
        end
        H(1:511, :) = cell2mat(H_cell(1:16));
        H(512:1022, :) = cell2mat(H_cell(17:32));

        % 生成G矩阵各子块(监督位编码部分)的首行数据
        fid = fopen(G_path, 'r');
        G_simplify = textscan(fid, '%s', 'Delimiter', '\n');
        G_simplify = G_simplify{1};
        fclose(fid);
        G_simplify = [G_simplify(1:2:end), G_simplify(2:2:end)]; % 第1、2个,第3、4个...子矩阵位于同一行
        G_simplify = cellfun(@(x) hexToBinaryVector(x, sub_matrix_size(1)+1), G_simplify, 'UniformOutput', false); % 将128个16进制数据转为512比特的二进制数据
        G_simplify = cellfun(@(x) x(2:end), G_simplify, 'UniformOutput', false); % 取低位(右侧高索引)的511个数据作为矩阵数据
        
        % 生成完整的G矩阵
        W = zeros(7154, 1022);
        for sub_num = 1:14
            G_sub_matrix_1 = zeros(sub_matrix_size(1), sub_matrix_size(2));
            G_sub_matrix_2 = zeros(sub_matrix_size(1), sub_matrix_size(2));
            G_sub_matrix_1(1, :) = G_simplify{sub_num, 1};
            G_sub_matrix_2(1, :) = G_simplify{sub_num, 2};
            for i = 2:sub_matrix_size(1) 
                G_sub_matrix_1(i, :) = [G_sub_matrix_1(i-1, end), G_sub_matrix_1(i-1, 1:end-1)];
                G_sub_matrix_2(i, :) = [G_sub_matrix_2(i-1, end), G_sub_matrix_2(i-1, 1:end-1)];
            end
            W(511*(sub_num-1)+1 : 511*sub_num, :) = [G_sub_matrix_1 G_sub_matrix_2]; 
        end
        G = [eye(7154, 7154) W];
    else
        AR4JA_matrix = load(sprintf('%s%s%s', "matrix_", stander, ".mat"));
        H = AR4JA_matrix.H;
        G = AR4JA_matrix.G;
        G_simplify = AR4JA_matrix.G_simplify;
        sub_matrix_size = [size(G_simplify{1,1}, 2) size(G_simplify{1,1}, 2)];
    end

end