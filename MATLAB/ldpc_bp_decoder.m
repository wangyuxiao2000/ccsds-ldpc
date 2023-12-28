%*************************************************************%
% function: LDPC概率域BP译码(基于软判决译码)
% Author  : WangYuxiao
% Email   : wyxee2000@163.com
% Data    : 2023.12.20
% Version : V 1.0
%*************************************************************%
function [result_message, result_full, right_flag] = ldpc_bp_decoder(yi, sigma2, H, iteratio_max)
    
    % 如果输入矩阵不是行向量，按行拼接并转换为行向量
    if ~isrow(yi) 
        yi = reshape(yi.', 1, []);
    end
    
    % 计算当前输入数据对应的LDPC码块个数
    n = size(H, 2);
    k = size(H, 2)-size(H, 1);
    block_num = floor(length(yi)/n);
    
    % 声明输出矩阵维度
    result_message = zeros(block_num, k);
    result_full = zeros(block_num, n);
    right_flag = zeros(block_num, 1);
    
    % 进行概率域BP译码
    for block_cnt = 1:block_num
        yi_reg = yi(n*(block_cnt-1)+1 : n*block_cnt);
        
        decision = zeros(1, n);           % 对软信息进行硬判决 
        decision(yi_reg <= 0) = 1;        % +1对应0,-1对应1
        check = sum(mod(decision*H', 2)); % 若硬判决结果能够正确译码(check为0),则不进行软迭代

        if(check~=0)
            % 初始化迭代次数
            num = 0;

            % 寻找比特节点i↔校验节点j的有效路径
            bit2check = zeros(2, sum(H(:)));                   % 第一行代表i值,第二行代表j值;每列代表一条比特节点到校验节点的路径
            [bit2check(2, :), bit2check(1, :)] = find(H == 1); % H的每一行代表一个校验方程，每一列代表一个比特节点

            check2bit = zeros(2, sum(H(:)));                   % 第一行代表j值,第二行代表i值;每列代表一条校验节点到比特节点的路径
            [check2bit(1, :), check2bit(2, :)] = find(H == 1);
            [~, sortOrder] = sort(check2bit(1, :));
            check2bit = check2bit(:, sortOrder);

            % 初始化比特节点的q_ij和校验节点的r_ji
            bit_node = zeros(2, size(bit2check, 2));              % 第一行为q_ij(+1),第二行为q_ij(-1)
            [p_i, init_value] = bp_bit_node_init(yi_reg, sigma2); % 计算各比特节点的后验概率
            for cnt = 1:size(bit2check, 2)                        % 初始化时,q_ij与j无关,即对于相同的比特节点(相同的i),q_ij是相同的
                bit_node(:, cnt) = init_value(:, bit2check(1, cnt));
            end
            check_node = zeros(2, size(check2bit, 2));            % 第一行为r_ji(+1),第二行为r_ji(-1)
        end

        while(check~=0 && num<iteratio_max)
            % 由上一次的q_ij更新校验节点的r_ji
            for cnt = 1:size(check2bit, 2)
                indices = find(bit2check(2, :) == check2bit(1, cnt) & bit2check(1, :) ~= check2bit(2, cnt));
                check_node(:, cnt) = [0.5 + 0.5 * prod(1 - 2*bit_node(2, indices)); 0.5 - 0.5 * prod(1 - 2*bit_node(2, indices))];
            end

            % 由刚刚得到的r_ji更新比特节点的q_ij
            for cnt = 1:size(bit2check, 2)
                indices = find(check2bit(2, :) == bit2check(1, cnt) & check2bit(1, :) ~= bit2check(2, cnt));
                bit_node(:, cnt) = [(1 - p_i(bit2check(1, cnt))) * prod(check_node(1, indices)); p_i(bit2check(1, cnt)) * prod(check_node(2, indices))];
                bit_node(:, cnt) = bit_node(:, cnt) ./ sum(bit_node(:, cnt));
            end

            % 由刚刚得到的r_ji计算APP似然比
            APP = zeros(2, size(H, 2));
            for cnt = 1:size(H, 2)
                indices = find(check2bit(2, :) == cnt);
                APP(:, cnt) = [(1 - p_i(cnt)) * prod(check_node(1, indices)); p_i(cnt) * prod(check_node(2, indices))];
                APP(:, cnt) = APP(:, cnt) ./ sum(APP(:, cnt));
            end

            % 根据似然比进行硬判决及校验
            decision = zeros(1, size(H, 2));
            decision(APP(1, :) <= 0.5) = 1; % +1对应0,-1对应1
            check = sum(mod(decision*H', 2));
            num = num + 1;
        end

        result_message(block_cnt, 1:k) = decision(1:k);
        result_full(block_cnt, 1:n) = decision;
        right_flag(block_cnt) = ~check;
    end
    
end