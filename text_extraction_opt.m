% 初始环境
clc
clear
close all

filename = 'SP-rotate.png'; % 嵌入了水印的图像，可能被攻击
stego = imread(filename);
origin_image = imread("B题-附件1.jpg");

% 预处理
% 旋转
angle = estimate_rotation_angle(stego);
restored_image = imrotate(stego, angle, 'bilinear', 'crop');

% 缩放
stego = imresize(stego, [1896, 1280]);

% 设置参数
alpha = 0.05; % 之前用来嵌入的强度
block_size = 8; % 之前用来嵌入的 DCT 块大小

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
[h, w, ~] = size(stego);

block_number = 984;
pixel_number = 10816;
recovered_watermark = zeros(11*block_number, 1, 3);

% 计数器
num = 0;

% 逐块进行 DCT 变换和水印提取
for i = 1:block_size:h-block_size+1
    for j = 1:block_size:w-block_size+1
        for channel = 1:3
            block = double(origin_image(i:i+block_size-1, j:j+block_size-1, channel));
            block_with_watermark = double(stego(i:i+block_size-1, j:j+block_size-1, channel));

            % 获取差图像
            block_diff_image = block_with_watermark - block;
    
            dct_block_diff_image = dct2(block_diff_image);
            coef = mid_freq_mask .* dct_block_diff_image;
            if num < block_number
                recovered_watermark(11*num+1:11*num+11, channel) = coef(mid_freq_ind) / alpha;
            end
        end
        num = num + 1;
    end
end

% 规格化水印图像
recovered_watermark(pixel_number+1:end) = [];
recovered_watermark = reshape(recovered_watermark, [104, 104]);

% 对图像进行还原
recovered_watermark = arnold_inverse(recovered_watermark, 10);

imshow(recovered_watermark);
title('Recovered Watermark');

imwrite(recovered_watermark, 'recovered_watermark.png');

origin_watermark = imread('watermark.png');

psnr_value = PSNR(origin_watermark, recovered_watermark);

exit_text = sprintf('还原完成，PSNR 值为 %f', psnr_value);

disp(exit_text)
