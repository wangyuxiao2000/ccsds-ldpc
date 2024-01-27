%*************************************************************%
% function: CCSDS-LDPC-深空AR4JA码 H/G矩阵生成
% Author  : WangYuxiao
% Email   : wyxee2000@163.com
% Data    : 2024.1.3
% Version : V 1.0
%*************************************************************%
% 初始化
clear; 
close all;
clc;

% 设置码型标准
stander = "1280_1024";
splitStr = split(stander, "_");
n = str2double(splitStr{1});
k = str2double(splitStr{2});

switch stander
    case "1280_1024"
        M = 128;
        pi_tot = 26;
    case "1536_1024"
        M = 256;
        pi_tot = 14;
    case "2048_1024"
        M = 512;
        pi_tot = 8;
    case "5120_4096"
        M = 512;
        pi_tot = 26;
    case "6144_4096"
        M = 1024;
        pi_tot = 14;
    case "8192_4096"
        M = 2048;
        pi_tot = 8;
    case "20480_16384"
        M = 2048;
        pi_tot = 26;
    case "24576_16384"
        M = 4096;
        pi_tot = 14;
    case "32768_16384"
        M = 8192;
        pi_tot = 8;
    otherwise
        error("Unsupported code type");
end

% 生成Π矩阵
theta_table = [3 0 1 2 2 3 0 1 0 1 2 0 2 3 0 1 2 0 1 2 0 1 2 1 2 3];
fai_table = cell(1, 4); % 4个cell依次对应φk(0,M)-φk(3,M)
fai_table{1, 1} = [1 59 16 160 108 226 1148;
                   22 18 103 241 126 618 2032;
                   0 52 105 185 238 404 249;
                   26 23 0 251 481 32 1807;
                   0 11 50 209 96 912 485;
                   10 7 29 103 28 950 1044;
                   5 22 115 90 59 534 717;
                   18 25 30 184 225 63 873;
                   3 27 92 248 323 971 364;
                   22 30 78 12 28 304 1926;
                   3 43 70 111 386 409 1241;
                   8 14 66 66 305 708 1769;
                   25 46 39 173 34 719 532;
                   25 62 84 42 510 176 768;
                   2 44 79 157 147 743 1138;
                   27 12 70 174 199 759 965;
                   7 38 29 104 347 674 141;
                   7 47 32 144 391 958 1527;
                   15 1 45 43 165 984 505;
                   10 52 113 181 414 11 1312;
                   4 61 86 250 97 413 1840;
                   19 10 1 202 158 925 709;
                   7 55 42 68 86 687 1427;
                   9 7 118 177 168 752 989;
                   26 12 33 170 506 867 1925;
                   17 2 126 89 489 323 270];
fai_table{1, 2} = [0 0 0 0 0 0 0;
                   27 32 53 182 375 767 1822;
                   30 21 74 249 436 227 203;
                   28 36 45 65 350 247 882;
                   7 30 47 70 260 284 1989;
                   1 29 0 141 84 370 957;
                   8 44 59 237 318 482 1705;
                   20 29 102 77 382 273 1083;
                   26 39 25 55 169 886 1072;
                   24 14 3 12 213 634 354;
                   4 22 88 227 67 762 1942;
                   12 15 65 42 313 184 446;
                   23 48 62 52 242 696 1456;
                   15 55 68 243 188 413 1940;
                   15 39 91 179 1 854 1660;
                   22 11 70 250 306 544 1661;
                   31 1 115 247 397 864 587;
                   3 50 31 164 80 82 708;
                   29 40 121 17 33 1009 1466;
                   21 62 45 31 7 437 433;
                   2 27 56 149 447 36 1345;
                   5 38 54 105 336 562 867;
                   11 40 108 183 424 816 1551;
                   26 15 14 153 134 452 2041;
                   9 11 30 177 152 290 1383;
                   17 18 116 19 492 778 1790];
fai_table{1, 3} = [0 0 0 0 0 0 0;
                   12 46 8 35 219 254 318;
                   30 45 119 167 16 790 494;
                   18 27 89 214 263 642 1467;
                   10 48 31 84 415 248 757;
                   16 37 122 206 403 899 1085;
                   13 41 1 122 184 328 1630;
                   9 13 69 67 279 518 64;
                   7 9 92 147 198 477 689;
                   15 49 47 54 307 404 1300;
                   16 36 11 23 432 698 148;
                   18 10 31 93 240 160 777;
                   4 11 19 20 454 497 1431;
                   23 18 66 197 294 100 659;
                   5 54 49 46 479 518 352;
                   3 40 81 162 289 92 1177;
                   29 27 96 101 373 464 836;
                   11 35 38 76 104 592 1572;
                   4 25 83 78 141 198 348;
                   8 46 42 253 270 856 1040;
                   2 24 58 124 439 235 779;
                   11 33 24 143 333 134 476;
                   11 18 25 63 399 542 191;
                   3 37 92 41 14 545 1393;
                   15 35 38 214 277 777 1752;
                   13 21 120 70 412 483 1627];
fai_table{1, 4} = [0 0 0 0 0 0 0
                   13 44 35 162 312 285 1189;
                   19 51 97 7 503 554 458;
                   14 12 112 31 388 809 460;
                   15 15 64 164 48 185 1039;
                   20 12 93 11 7 49 1000;
                   17 4 99 237 185 101 1265;
                   4 7 94 125 328 82 1223;
                   4 2 103 133 254 898 874;
                   11 30 91 99 202 627 1292;
                   17 53 3 105 285 154 1491;
                   20 23 6 17 11 65 631;
                   8 29 39 97 168 81 464;
                   22 37 113 91 127 823 461;
                   19 42 92 211 8 50 844;
                   15 48 119 128 437 413 392;
                   5 4 74 82 475 462 922;
                   21 10 73 115 85 175 256;
                   17 18 116 248 419 715 1986;
                   9 56 31 62 459 537 19;
                   20 9 127 26 468 722 266;
                   18 11 98 140 209 37 471;
                   31 23 23 121 311 488 1166;
                   13 8 38 12 211 179 1300;
                   2 7 18 41 510 430 1033;
                   18 24 62 249 320 264 1606];
pi_matrix = cell(1, pi_tot);
pi_matrix = cellfun(@(x) zeros(M, M), pi_matrix, 'UniformOutput', false);
one_positon = zeros(1, M);
for pi_num = 1:pi_tot
    one_positon = M/4 * mod((repmat(theta_table(pi_num), 1, M) + floor(4*(0:M-1)/M)), 4) + mod(cellfun(@(cell) cell(pi_num, log2(M)-6), fai_table(1, floor(4*(0:M-1)/M)+1)) + (0:M-1), M/4) + 1;
    pi_matrix{1, pi_num}(sub2ind(size(pi_matrix{1, pi_num}), 1:M, one_positon)) = 1;
end

% 生成H矩阵
switch stander
    case {"1280_1024", "5120_4096", "20480_16384"} % 4/5码率
        H = cell(3, 11);
        H = cellfun(@(x) zeros(M, M), H, 'UniformOutput', false);
        H{1, 9} = eye(M, M);
        H{1, 11} = mod(eye(M, M) + pi_matrix{1, 1}, 2);
        H{2, 1} = mod(pi_matrix{1, 21} + pi_matrix{1, 22} + pi_matrix{1, 23}, 2);
        H{2, 2} = eye(M, M);
        H{2, 3} = mod(pi_matrix{1, 15} + pi_matrix{1, 16} + pi_matrix{1, 17}, 2);
        H{2, 4} = eye(M, M);
        H{2, 5} = mod(pi_matrix{1, 9} + pi_matrix{1, 10} + pi_matrix{1, 11}, 2);
        H{2, 6} = eye(M, M);
        H{2, 7} = eye(M, M);
        H{2, 8} = eye(M, M);
        H{2, 10} = eye(M, M);
        H{2, 11} = mod(pi_matrix{1, 2} + pi_matrix{1, 3} + pi_matrix{1, 4}, 2);
        H{3, 1} = eye(M, M);
        H{3, 2} = mod(pi_matrix{1, 24} + pi_matrix{1, 25} + pi_matrix{1, 26}, 2);
        H{3, 3} = eye(M, M);
        H{3, 4} = mod(pi_matrix{1, 18} + pi_matrix{1, 19} + pi_matrix{1, 20}, 2);
        H{3, 5} = eye(M, M);
        H{3, 6} = mod(pi_matrix{1, 12} + pi_matrix{1, 13} + pi_matrix{1, 14}, 2);
        H{3, 7} = eye(M, M);
        H{3, 8} = mod(pi_matrix{1, 5} + pi_matrix{1, 6}, 2);
        H{3, 10} = mod(pi_matrix{1, 7} + pi_matrix{1, 8}, 2);
        H{3, 11} = eye(M, M);
        H = cell2mat(cellfun(@(x) reshape(x, size(x, 1), []), H, 'UniformOutput', false));
        Q = H(:, 1:8*M);
        P = H(:, end-3*M+1:end);
    case {"1536_1024", "6144_4096", "24576_16384"} % 2/3码率
        H = cell(3, 7);
        H = cellfun(@(x) zeros(M, M), H, 'UniformOutput', false);
        H{1, 5} = eye(M, M);
        H{1, 7} = mod(eye(M, M) + pi_matrix{1, 1}, 2);
        H{2, 1} = mod(pi_matrix{1, 9} + pi_matrix{1, 10} + pi_matrix{1, 11}, 2);
        H{2, 2} = eye(M, M);
        H{2, 3} = eye(M, M);
        H{2, 4} = eye(M, M);
        H{2, 6} = eye(M, M);
        H{2, 7} = mod(pi_matrix{1, 2} + pi_matrix{1, 3} + pi_matrix{1, 4}, 2);
        H{3, 1} = eye(M, M);
        H{3, 2} = mod(pi_matrix{1, 12} + pi_matrix{1, 13} + pi_matrix{1, 14}, 2);
        H{3, 3} = eye(M, M);
        H{3, 4} = mod(pi_matrix{1, 5} + pi_matrix{1, 6}, 2);
        H{3, 6} = mod(pi_matrix{1, 7} + pi_matrix{1, 8}, 2);
        H{3, 7} = eye(M, M);
        H = cell2mat(cellfun(@(x) reshape(x, size(x, 1), []), H, 'UniformOutput', false));
        Q = H(:, 1:4*M);
        P = H(:, end-3*M+1:end);
    case {"2048_1024", "8192_4096", "32768_16384"} % 1/2码率
        H = cell(3, 5);
        H = cellfun(@(x) zeros(M, M), H, 'UniformOutput', false);
        H{1, 3} = eye(M, M);
        H{1, 5} = mod(eye(M, M) + pi_matrix{1, 1}, 2);
        H{2, 1} = eye(M, M);
        H{2, 2} = eye(M, M);
        H{2, 4} = eye(M, M);
        H{2, 5} = mod(pi_matrix{1, 2} + pi_matrix{1, 3} + pi_matrix{1, 4}, 2);
        H{3, 1} = eye(M, M);
        H{3, 2} = mod(pi_matrix{1, 5} + pi_matrix{1, 6}, 2);
        H{3, 4} = mod(pi_matrix{1, 7} + pi_matrix{1, 8}, 2);
        H{3, 5} = eye(M, M);
        H = cell2mat(cellfun(@(x) reshape(x, size(x, 1), []), H, 'UniformOutput', false));
        Q = H(:, 1:2*M);
        P = H(:, end-3*M+1:end);
    otherwise
        error("不支持的码型");
end

% 计算G矩阵
P_inv = mod2_inv(P);
W = mod((P_inv*Q)', 2);
G = [eye(size(W, 1), size(W, 1)) W];

% 计算G矩阵各子块(监督位编码部分)的首行数据
m = M/4;
W_valid = W(:, 1:end-M);
G_simplify = cell(size(W_valid, 1)/m, size(W_valid, 2)/m);

for i = 1:size(W_valid, 1)/m % 行循环
    for j = 1:size(W_valid, 2)/m % 列循环
        row_range = (i-1)*m + 1;
        col_range = (j-1)*m + 1 : j*m;
        G_simplify{i, j} = W_valid(row_range, col_range);
    end
end

% 将完整H、G矩阵及G矩阵的简化表示存入mat文件中
switch stander
    case "1280_1024"
        matrix_1280_1024.H = H;
        matrix_1280_1024.G = G;
        matrix_1280_1024.G_simplify = G_simplify;
        save('matrix_1280_1024.mat', '-struct', 'matrix_1280_1024','-v7.3');
    case "1536_1024"
        matrix_1536_1024.H = H;
        matrix_1536_1024.G = G;
        matrix_1536_1024.G_simplify = G_simplify;
        save('matrix_1536_1024.mat', '-struct', 'matrix_1536_1024','-v7.3');
    case "2048_1024"
        matrix_2048_1024.H = H;
        matrix_2048_1024.G = G;
        matrix_2048_1024.G_simplify = G_simplify;
        save('matrix_2048_1024.mat', '-struct', 'matrix_2048_1024','-v7.3');
    case "5120_4096"
        matrix_5120_4096.H = H;
        matrix_5120_4096.G = G;
        matrix_5120_4096.G_simplify = G_simplify;
        save('matrix_5120_4096.mat', '-struct', 'matrix_5120_4096','-v7.3');
    case "6144_4096"
        matrix_6144_4096.H = H;
        matrix_6144_4096.G = G;
        matrix_6144_4096.G_simplify = G_simplify;
        save('matrix_6144_4096.mat', '-struct', 'matrix_6144_4096','-v7.3');
    case "8192_4096"
        matrix_8192_4096.H = H;
        matrix_8192_4096.G = G;
        matrix_8192_4096.G_simplify = G_simplify;
        save('matrix_8192_4096.mat', '-struct', 'matrix_8192_4096','-v7.3');
    case "20480_16384"
        matrix_20480_16384.H = H;
        matrix_20480_16384.G = G;
        matrix_20480_16384.G_simplify = G_simplify;
        save('matrix_20480_16384.mat', '-struct', 'matrix_20480_16384','-v7.3');
    case "24576_16384"
        matrix_24576_16384.H = H;
        matrix_24576_16384.G = G;
        matrix_24576_16384.G_simplify = G_simplify;
        save('matrix_24576_16384.mat', '-struct', 'matrix_24576_16384','-v7.3');
    case "32768_16384"
        matrix_32768_16384.H = H;
        matrix_32768_16384.G = G;
        matrix_32768_16384.G_simplify = G_simplify;
        save('matrix_32768_16384.mat', '-struct', 'matrix_32768_16384','-v7.3');
    otherwise
        error("不支持的码型");
end


% 子函数:求矩阵的模二逆
function inv_mod_2 = mod2_inv(input_matrix)

    % 检查输入格式
    [m, n] = size(input_matrix);
    if m ~= n
        error("输入矩阵必须是方阵");
    end
    if rank(input_matrix) ~=m
        error("输入矩阵不可逆");
    end
    
    % 创建增广矩阵 [input_matrix | I]
    augmented_matrix = [input_matrix eye(m)];
    
    % 对增广矩阵进行高斯消元
    for i = 1:m
        % 找到非零主元素，如果当前主元素为零则进行行交换
        non_zero_row = find(augmented_matrix(i:end, i), 1) + i - 1;
        augmented_matrix([i, non_zero_row], :) = augmented_matrix([non_zero_row, i], :);
        
        % 将当前列的主元素缩放为1
        augmented_matrix(i, :) = mod(augmented_matrix(i, :) / augmented_matrix(i, i), 2);
        
        % 消元操作
        for j = 1:m
            if i ~= j
                augmented_matrix(j, :) = mod(augmented_matrix(j, :) - augmented_matrix(j, i) * augmented_matrix(i, :), 2);
            end
        end
        disp(i);
    end
    
    % 提取逆矩阵部分
    inv_mod_2 = augmented_matrix(:, m+1:end);

end