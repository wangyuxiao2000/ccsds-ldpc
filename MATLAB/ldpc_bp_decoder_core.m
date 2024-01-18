%*************************************************************%
% function: LDPC 概率域BP解码核心算法
% Author  : WangYuxiao
% Email   : wyxee2000@163.com
% Data    : 2023.12.21
% Version : V 1.0
%*************************************************************%
function [result_message, result_full, right_flag] = ldpc_bp_decoder_core(yi, n, k, H, block_num, sigma2, iteratio_max)
   
    % 声明输出矩阵维度
    result_message = zeros(block_num, k);
    result_full = zeros(block_num, n);
    right_flag = zeros(block_num, 1);
    
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
            [bit2check(2, :), bit2check(1, :)] = find(H == 1); % H的每一行代表一个校验方程,每一列代表一个比特节点

            check2bit = zeros(2, sum(H(:)));                   % 第一行代表j值,第二行代表i值;每列代表一条校验节点到比特节点的路径
            [check2bit(1, :), check2bit(2, :)] = find(H == 1);
            [~, sortOrder] = sort(check2bit(1, :));
            check2bit = check2bit(:, sortOrder);

            % 初始化比特节点的q_ij和校验节点的r_ji
            bit_node = zeros(2, size(bit2check, 2));              % 第一行为q_ij(+1),第二行为q_ij(-1)
            [p_i, init_value] = bp_bit_node_init(yi_reg, sigma2); % 计算各比特节点的后验概率(bp_bit_node_init函数请见第80行)
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

function [p_i, q_ij] = bp_bit_node_init(yi, sigma2)
    
    % 声明输出矩阵维度
    p_i = zeros(1, length(yi));  % [p_1, p_2, ... , p_n]
    q_ij = zeros(2, length(yi)); % [q_1j(+1), q_2j(+1), ... , q_nj(+1); q_1j(-1), q_2j(-1), ... , q_nj(-1)]
 
    % 计算比特节点初始化信息
    for cnt = 1:length(yi)
        p_i(cnt) = 1 / (1 + exp(2*yi(cnt)/sigma2));
        q_ij(1, cnt) = 1-p_i(cnt); % q_ij(+1)
        q_ij(2, cnt) = p_i(cnt);   % q_ij(-1)
    end
    
end