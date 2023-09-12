function stego = F5_in(cover, data)
    %% 标准量化表
    Q = [16 11 10 16 24 40 51 61;
         12 12 14 19 26 58 60 55;
         14 13 16 24 40 57 69 56;
         14 17 22 29 51 87 80 62;
         18 22 37 56 68 109 103 77;
         24 35 55 64 81 104 113 92;
         49 64 78 87 103 121 120 101;
         72 92 95 98 112 100 103 99];
    Q = Q * 0.6;
    M = [0 0 0 1 1 1 1;
         0 1 1 0 0 1 1;
         1 0 1 0 1 0 1];   % 校验矩阵
    data_len = numel(data);
    %% 初始化，DCT转换和量化
    [h, w] = size(cover);
    D = zeros(h, w);           % 零时存储矩阵
    for i = 1:h/8
        for j = 1:w/8
            D(8*(i-1)+1:8*i, 8*(j-1)+1:8*j) = dct2(cover(8*(i-1)+1:8*i, 8*(j-1)+1:8*j));
            D(8*(i-1)+1:8*i, 8*(j-1)+1:8*j) = round(D(8*(i-1)+1:8*i, 8*(j-1)+1:8*j) ./ Q);
        end
    end
    %% 嵌入data(k)
    stego = D;
    num = 1;          % 记录目前已经嵌入的data数量
    a = zeros(7, 1);
    k = 1;            % 记录当前7个数值中已取数量
    sit = zeros(7, 2); % 记录当前7个数在stego中的位置
    for i = 1:h
        for j = 1:w
            if (D(i, j) > 0 && mod(D(i, j), 2) == 1) || (D(i, j) < 0 && mod(D(i, j), 2) == 0)        % 正奇数或负偶数为1
                a(k) = 1;
                sit(k, 1) = i;
                sit(k, 2) = j;
                k = k + 1;
            elseif (D(i, j) < 0 && mod(D(i, j), 2) == 1) || (D(i, j) > 0 && mod(D(i, j), 2) == 0)    % 负奇数或正偶数为0
                a(k) = 0;
                sit(k, 1) = i;
                sit(k, 2) = j;
                k = k + 1;
            end
            if (k > 7)
                data_bit = [data(num), data(num+1), data(num+2)]';  % 8进制转换为2进制
                temp = M * a;
                temp = mod(temp, 2);
                n = bitxor(data_bit, temp);      % 异或
                n = n(1) * 4 + n(2) * 2 + n(3);
                %% 修改第n位的DCT值
                if n > 0      % 需要修改，否则不需要修改
                    if D(sit(n, 1), sit(n, 2)) < 0
                        stego(sit(n, 1), sit(n, 2)) = D(sit(n, 1), sit(n, 2)) + 1;
                    elseif D(sit(n, 1), sit(n, 2)) > 0
                        stego(sit(n, 1), sit(n, 2)) = D(sit(n, 1), sit(n, 2)) - 1;
                    end
                    %% 检查修改过后的DCT值是否为0，若为0则重新选择1位数据作为载体信号
                    if stego(sit(n, 1), sit(n, 2)) == 0
                        k = k - 1;
                        sit(n:k-1, :) = sit(n+1:k, :);
                        a(n:k-1) = a(n+1:k);
                        continue;
                    end
                end
                num = num + 3;
                k = 1;
            end
            if (num > data_len)
                break;
            end
        end
        if (num > data_len)
            break;
        end
    end
    %% DCT转换，转换成伪装图像
    for i = 1:h/8
        for j = 1:w/8
            stego(8*(i-1)+1:8*i, 8*(j-1)+1:8*j) = stego(8*(i-1)+1:8*i, 8*(j-1)+1:8*j) .* Q;
            stego(8*(i-1)+1:8*i, 8*(j-1)+1:8*j) = idct2(stego(8*(i-1)+1:8*i, 8*(j-1)+1:8*j));
        end
    end
    stego = uint8(stego);
end
