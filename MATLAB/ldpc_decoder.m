%*************************************************************%
% function: LDPC BP译码(适配CCSDS协议)
% Author  : WangYuxiao
% Email   : wyxee2000@163.com
% Data    : 2023.12.20
% Version : V 1.0
%*************************************************************%
function [result_message, result_full, right_flag] = ldpc_decoder(stander, rx_simple, sigma2, iteratio_max, method)
    
    % 如果输入矩阵不是行向量,提示错误信息
    if size(rx_simple, 1) ~= 1
        error("Input must be a row vector.");
    end
    
    % 产生H矩阵
    [H, ~, ~, ~, ~, ~] = H_G_generator(stander);
    
    % 提取当前码字的(n, k)参数
    splitStr = split(stander, "_");
    n = str2double(splitStr{1});
    k = str2double(splitStr{2});
    
    % 计算当前输入数据对应的LDPC码块个数
    block_num = floor(length(rx_simple)/n);
    yi = rx_simple(1:block_num*n);
    
    % 进行译码
    if stander == "8160_7136"
        yi = reshape(yi, n, block_num).';
        yi = [ones(block_num, 18), yi(:, 1:end-2)];
        yi = reshape(yi.', 1, []);
        if method == "BP"
            [result_message, result_full, right_flag] = ldpc_bp_decoder_core(yi, 8176, 7154, H, block_num, sigma2, iteratio_max);
        elseif method == "LLR BP"
            [result_message, result_full, right_flag] = ldpc_llr_bp_decoder_core(yi, 8176, 7154, H, block_num, sigma2, iteratio_max);
        elseif method == "UMP BP"
            [result_message, result_full, right_flag] = ldpc_ump_bp_decoder_core(yi, 8176, 7154, H, block_num, iteratio_max);
        else
            error("Unsupported decoding method.");
        end
        result_message = result_message(:, 19:end);
        result_full = [result_full(:, 19:end), zeros(size(result_full, 1), 2)];
    elseif stander == "8176_7154"
        if method == "BP"
            [result_message, result_full, right_flag] = ldpc_bp_decoder_core(yi, n, k, H, block_num, sigma2, iteratio_max);
        elseif method == "LLR BP"
            [result_message, result_full, right_flag] = ldpc_llr_bp_decoder_core(yi, n, k, H, block_num, sigma2, iteratio_max);
        elseif method == "UMP BP"
            [result_message, result_full, right_flag] = ldpc_ump_bp_decoder_core(yi, n, k, H, block_num, iteratio_max);
        else
            error("Unsupported decoding method.");
        end
    else
        switch stander
            case "1280_1024"
                M = 128;                
            case "1536_1024"
                M = 256;
            case "2048_1024"
                M = 512;
            case "5120_4096"
                M = 512;
            case "6144_4096"
                M = 1024;
            case "8192_4096"
                M = 2048;
            case "20480_16384"
                M = 2048;
            case "24576_16384"
                M = 4096;
            case "32768_16384"
                M = 8192;
            otherwise
                error("Unsupported code type");
        end
        dummy_bit = zeros(1, M); % 对打孔位置填充0信息,使这些比特节点关于-1/+1的后验概率相等
        yi = reshape(yi, n, block_num).';
        yi = [yi repmat(dummy_bit, block_num, 1)];
        yi = reshape(yi.', 1, []);
        if method == "BP"
            [result_message, result_full, right_flag] = ldpc_bp_decoder_core(yi, n+M, k, H, block_num, sigma2, iteratio_max);
        elseif method == "LLR BP"
            [result_message, result_full, right_flag] = ldpc_llr_bp_decoder_core(yi, n+M, k, H, block_num, sigma2, iteratio_max);
        elseif method == "UMP BP"
            [result_message, result_full, right_flag] = ldpc_ump_bp_decoder_core(yi, n+M, k, H, block_num, iteratio_max);
        else
            error("Unsupported decoding method.");
        end
    end
    
end