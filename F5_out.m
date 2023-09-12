function extract = F5_out(stego, data_len)
    %% 初始化
    Q = [16 11 10 16 24 40 51 61;
         12 12 14 19 26 58 60 55;
         14 13 16 24 40 57 69 56;
         14 17 22 29 51 87 80 62;
         18 22 37 56 68 109 103 77;
         24 35 55 64 81 104 113 92;
         49 64 78 87 103 121 120 101;
         72 92 95 98 112 100 103 99]; % 标准量化表
    Q = Q * 0.6;
    [h, w] = size(stego);
    M = [0 0 0 1 1 1 1;
         0 1 1 0 0 1 1;
         1 0 1 0 1 0 1];     % 校验矩阵
    D = zeros(h, w);           % 零时存储矩阵
    %% DCT转换和量化
    for i = 1:h/8
        for j = 1:w/8
            D(8*(i-1)+1:8*i, 8*(j-1)+1:8*j) = dct2(stego(8*(i-1)+1:8*i, 8*(j-1)+1:8*j));
            D(8*(i-1)+1:8*i, 8*(j-1)+1:8*j) = round(D(8*(i-1)+1:8*i, 8*(j-1)+1:8*j) ./ Q);
        end
    end
    %% 数据提取
    num = 1;          % 记录目前已经提取的data数量
    a = zeros(7, 1);
    k = 1;            % 记录当前7个数值中已取数量
    extract = [];     % 记录结果
    for i = 1:h
        for j = 1:w
            % 正奇数或负偶数为 1
            if (D(i, j) > 0 && mod(D(i, j), 2) == 1) || (D(i, j) < 0 && mod(D(i, j), 2) == 0)
                a(k) = 1;
                k = k + 1;
            % 负奇数或正偶数为 0
            elseif (D(i, j) < 0 && mod(D(i, j), 2) == 1) || (D(i, j) > 0 && mod(D(i, j), 2) == 0)
                a(k) = 0;
                k = k + 1;
            end
            if k > 7  % 表示集满 7 个数据
                temp = M * a;
                temp = mod(temp, 2);
                % 存入结果
                extract(num:num+2) = temp;
                num = num + 3;
                k = 1;
            end
            if num > data_len
                break;
            end
        end
        if num > data_len
            break;
        end
    end
end
