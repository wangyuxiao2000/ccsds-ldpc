function [yi, Eb_N0_real, sigma2] = ldpc_noise_adder(xi, Eb_N0_request)
    
    noise = wgn(1,length(xi),-3.01-Eb_N0_request);      % 生成高斯白噪声:认为接收到±1信号已经是最佳接收机的输出Eb,则Eb/N0 = 1/(2*sigma2)
    yi = xi + noise;                                    % 加噪后的信号
    sigma2 = mean(noise.^2);                            % 计算高斯白噪声的W功率
    Eb_N0_real = -3.01 - 10*log10(sigma2);              % 实际的Eb/N0
    
end