% 初始环境
clc
clear
close all

filename = 'B题-附件1.jpg';
cover = imread(filename);

% 读取水印图像
watermark = imread('watermark.png');

% 对图像进行 Arnold 置乱，迭代次数为 10
watermark = arnold_transform(watermark, 10);

% 这里，使用 DCT 技术嵌入数字水印，水印图片为 watermark.png
% 设置参数
alpha = 0.05; % 调整嵌入强度
block_size = 8; % DCT 块的大小

low_freq_mask = [
    1 1 1 1 0 0 0 0;
    1 1 1 0 0 0 0 0;
    1 1 0 0 0 0 0 0;
    1 0 0 0 0 0 0 0;
    0 0 0 0 0 0 0 0;
    0 0 0 0 0 0 0 0;
    0 0 0 0 0 0 0 0;
    0 0 0 0 0 0 0 0;
];

low_freq_ind = find(low_freq_mask == 1);

mid_freq_mask = [
    0 0 0 0 1 1 0 0;
    0 0 0 1 1 0 0 0;
    0 0 1 1 0 0 0 0;
    0 1 1 0 0 0 0 0;
    1 1 0 0 0 0 0 0;
    1 0 0 0 0 0 0 0;
    0 0 0 0 0 0 0 0;
    0 0 0 0 0 0 0 0;
];

mid_freq_ind = find(mid_freq_mask == 1);

% 获取图像尺寸
[h, w, ~] = size(cover);

% imshow(watermark, []);
% title('Original Watermark');

% 获取水印尺寸
[m, n, ~] = size(watermark);
pixel_number = m * n;
block_number = ceil(pixel_number / 11);  % 水印图像按照 11 个元素划分为 1 块
watermark = reshape(watermark, [], 3);

% 计算需要补0的行数
for channel = 1:3
    watermark(pixel_number+1:11*block_number, channel) = 0;  % 不足补 0
end

num = 0;  % 嵌入水印块计数器

% 逐块、逐通道进行 DCT 变换和水印嵌入
for i = 1:block_size:h-block_size+1
    for j = 1:block_size:w-block_size+1
        for channel = 1:3
            block = double(cover(i:i+block_size-1, j:j+block_size-1, channel));
            dct_block = dct2(block);

            % DCT 变换后取出中低频系数，作为合成子块初始值
            coef = (low_freq_mask + mid_freq_mask) .* dct_block;

            if num < block_number
                % 在中频嵌入信息
                coef(mid_freq_ind) = coef(mid_freq_ind) + alpha * double(watermark(11*num+1:11*num+11, channel));
            end

            % 逆 DCT 变换，存入合成子块
            cover(i:i+block_size-1, j:j+block_size-1, channel) = idct2(coef);
        end
        num = num + 1;
    end
end

imshow(cover);
imwrite(cover, 'SP.png');
disp('嵌入完成');
