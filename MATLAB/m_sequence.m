function m_sequence = m_sequence(seed, ploy, length)

    % 设置输出矩阵维度
    m_sequence = zeros(1, length);
    
    % 初始化种子值
    register = seed;
    
    % m序列的生成向量从左到右，对应生成多项式由高次到低次，对应寄存器从右到左
    ploy = fliplr(ploy);
    
    % 生成m序列
    for i = 1:length
        % 计算反馈值
        feedback = mod(sum(bitand(register, ploy(2:end))), 2);
        
        % 输出尾部寄存器的值作为m序列
        m_sequence(i) = register(end);
        
        % 更新寄存器状态
        register = [feedback, register(1:end-1)];
    end
end
