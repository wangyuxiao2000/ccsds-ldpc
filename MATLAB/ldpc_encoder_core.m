%*************************************************************%
% function: QC-LDPC编码核心算法
% Author  : WangYuxiao
% Email   : wyxee2000@163.com
% Data    : 2023.12.21
% Version : V 1.0
%*************************************************************%
function [result] = ldpc_encoder_core(usr_data, n, k, G_sub_matrix, G_sub_matrix_size, block_num)
    
    % 如果输入矩阵不是行向量,提示错误信息
    if size(usr_data, 1) ~= 1
        error("Input must be a row vector.");
    end
    
    % 声明输出矩阵维度
    result = zeros(block_num, n);
    
    % 计算LDPC块编码
    for block_cnt = 1:block_num
        usr_data_reg = usr_data(k*(block_cnt-1)+1 : k*block_cnt);
        
        current_cell = G_sub_matrix(1, :);
        current_row = cellfun(@(row) cat(2, row{:}), num2cell(current_cell, 2), 'UniformOutput', false);
        
        encoder_result = zeros(1, n);
        check_bit = zeros(1, n-k);
        
        for encode_cnt = 1:k
            encoder_result(encode_cnt) = usr_data_reg(encode_cnt);
            if usr_data_reg(encode_cnt) == 1 % 根据当前输入的信息位,更新校验位
                check_bit = bitxor(check_bit, current_row{1});
            end
            if mod(encode_cnt, G_sub_matrix_size(1))==0 && encode_cnt~=k % 切换G矩阵子块
                current_cell = G_sub_matrix(encode_cnt/G_sub_matrix_size(1) + 1, :);
            else % 对G矩阵的当前行进行循环移位
                current_cell = cellfun(@(x) circshift(x, [0, 1]), current_cell, 'UniformOutput', false);
            end
            current_row = cellfun(@(row) cat(2, row{:}), num2cell(current_cell, 2), 'UniformOutput', false);
        end
        encoder_result(k+1:n) = check_bit;
        
        result(block_cnt, 1:n) = encoder_result;
    end

end