%*************************************************************%
% function: LDPC UMP BP解码核心算法
% Author  : WangYuxiao
% Email   : wyxee2000@163.com
% Data    : 2024.1.31
% Version : V 1.0
%*************************************************************%
function [result_message, result_full, right_flag] = ldpc_ump_bp_decoder_core(yi, n, k, H, block_num, iteratio_max)
   
    % 如果输入矩阵不是行向量,提示错误信息
    if size(yi, 1) ~= 1
        error("Input must be a row vector.");
    end
    
    % 声明输出矩阵维度
    result_message = zeros(block_num, k);
    result_full = zeros(block_num, n);
    right_flag = zeros(block_num, 1);
    
   for block_cnt = 1:block_num
        yi_reg = yi(n*(block_cnt-1)+1 : n*block_cnt);
        
        decision = zeros(1, n);           % 对软信息进行硬判决 
        decision(yi_reg <= 0) = 1;        % +1对应0,-1对应1
        check = sum(mod(decision*H', 2)); % 若硬判决结果能够正确译码(check为0),则不进行软迭代

        if check ~= 0
            % 初始化迭代次数
            num = 0;

            % 寻找比特节点i↔校验节点j的有效路径
            bit2check = zeros(2, sum(H(:)));                   % 第一行代表i值,第二行代表j值;每列代表一条比特节点到校验节点的路径
            [bit2check(2, :), bit2check(1, :)] = find(H == 1); % H的每一行代表一个校验方程,每一列代表一个比特节点

            check2bit = zeros(2, sum(H(:)));                   % 第一行代表j值,第二行代表i值;每列代表一条校验节点到比特节点的路径
            [check2bit(1, :), check2bit(2, :)] = find(H == 1);
            [~, sortOrder] = sort(check2bit(1, :));
            check2bit = check2bit(:, sortOrder);

            % 初始化比特节点的L(q_ij)和校验节点的L(r_ji)
            bit_node = zeros(1, size(bit2check, 2));        % 比特节点L(q_ij)
            L_i = yi_reg;                                   % 计算各比特节点的初始信息
            for cnt = 1:size(bit2check, 2)                  % 初始化时,q_ij与j无关,即对于相同的比特节点(相同的i),q_ij是相同的
                bit_node(cnt) = L_i(bit2check(1, cnt));
            end
            check_node = zeros(1, size(check2bit, 2));      % 校验节点L(r_ji)
        end

        while check~=0 && num<iteratio_max
            % 由上一次的L(q_ij)更新校验节点的L(r_ji)
            a = sign(bit_node);
            b = abs(bit_node);
            for cnt = 1:size(check2bit, 2)
                indices = find(bit2check(2, :) == check2bit(1, cnt) & bit2check(1, :) ~= check2bit(2, cnt));
                check_node(cnt) = prod(a(indices)) * min(b(indices)); 
            end

            % 由刚刚得到的L(r_ji)更新比特节点的L(q_ij)
            for cnt = 1:size(bit2check, 2)
                indices = find(check2bit(2, :) == bit2check(1, cnt) & check2bit(1, :) ~= bit2check(2, cnt));
                bit_node(cnt) = L_i(bit2check(1, cnt)) + sum(check_node(indices));
            end

            % 由刚刚得到的L(r_ji)计算似然比
            Q = zeros(1, n);
            for cnt = 1:n
                indices = find(check2bit(2, :) == cnt);
                Q(cnt) = L_i(cnt) + sum(check_node(indices));
            end

            % 根据似然比进行硬判决及校验
            decision = zeros(1, n);
            decision(Q(1, :) <= 0) = 1; % +1对应0,-1对应1
            check = sum(mod(decision*H', 2));
            num = num + 1;
        end

        result_message(block_cnt, 1:k) = decision(1:k);
        result_full(block_cnt, 1:n) = decision;
        right_flag(block_cnt) = ~check;
    end

end