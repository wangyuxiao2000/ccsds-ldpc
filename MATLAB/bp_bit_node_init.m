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