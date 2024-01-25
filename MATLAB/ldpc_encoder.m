%*************************************************************%
% function: QC-LDPC编码(适配CCSDS协议)
% Author  : WangYuxiao
% Email   : wyxee2000@163.com
% Data    : 2023.1.3
% Version : V 1.0
%*************************************************************%
function result = ldpc_encoder(stander, usr_data) % result的每行是一个码字

    % 如果输入矩阵不是行向量,提示错误信息
    if ~isrow(usr_data) 
        error("Input must be a row vector.");
    end
    
    % 产生H/G矩阵
    [H, ~, G_simplify, sub_matrix_size] = H_G_generator(stander);
    
    % 提取当前码字的(n, k)参数
    splitStr = split(stander, "_");
    n = str2double(splitStr{1});
    k = str2double(splitStr{2});
    
    % 计算当前输入数据对应的码块个数
    block_num = floor(numel(usr_data)/k);
    usr_data_valid = usr_data(1:block_num*k);
    
    % 进行编码
    if (stander == "8160_7136")
        % 进行虚拟填充(7136bit用户数据的首部添加18bit的0,得到一个LDPC码块编码所需的7154bit信息位)
        usr_data_valid = reshape(usr_data_valid, 7136, block_num)';
        ccsds_usr_data = [zeros(block_num, 18), usr_data_valid];
        ccsds_usr_data = reshape(ccsds_usr_data.', 1, []);
        
        % 进行(8176, 7154)LDPC编码
        encoder_result = ldpc_encoder_core(ccsds_usr_data, 8176, 7154, G_simplify, sub_matrix_size, block_num);
    
        % 校验编码结果是否正确
        check_result = mod(encoder_result* H', 2);
        if (sum(check_result(:)) ~= 0)
            error("LDPC coding error.");
        end

        % 对每个LDPC码块编码得到的8176bit去除18bit虚拟填充,并在尾部添加2bit的0
        result = [encoder_result(:, 19:end), zeros(size(encoder_result, 1), 2)];
    else
        % 进行(n, k)LDPC编码
        result = ldpc_encoder_core(usr_data_valid, n, k, G_simplify, sub_matrix_size, block_num);
    
        % 校验编码结果是否正确
        % check_result = mod(result*H', 2);
        % if (sum(check_result(:)) ~= 0)
        %     error("LDPC coding error.");
        % end
    end

end