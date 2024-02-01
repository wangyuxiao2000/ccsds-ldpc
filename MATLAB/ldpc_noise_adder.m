function [yi, Eb_N0_real, sigma2] = ldpc_noise_adder(xi, Eb_N0_request, n, k)
    
    M = 2;  % 调制进制数
    Es = 1; % 星座点的平均符号能量
    sigma2 = -Eb_N0_request - 10*log10(k/n) - 10*log10(log2(M)) - 10*log10(2/Es); % 高斯白噪声的dB功率(推导请见Reference文件夹"Eb_N0.png")

    noise = wgn(numel(xi)/n, n, sigma2);                  % 为每个输入码块分别生成高斯白噪声
    noise = reshape(noise.', 1, []);
    yi = xi + noise;                                      % 加噪后的信号
    sigma2 = mean(noise.^2);                              % 计算高斯白噪声的W功率
    Eb_N0_real = 10*log10(n/(2*k)) - 10*log10(sigma2);    % 实际的Eb/N0
    
end