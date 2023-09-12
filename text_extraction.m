% 初始环境
clc
clear
close all

% 图片名
filename = 'SP.png';

% 读取生成的压缩图像的数据
cover = imread(filename);

% 如果图片大小不一致，则需要缩放图片至 1896x1280
targetSize = [1896, 1280];
if size(cover, 1) ~= targetSize(1) || size(cover, 2) ~= targetSize(2)
    cover = imresize(cover, targetSize);
end

% 获取单个通道
red_channel = cover(:,:,1);  % 1896x1280 红色通道

% F5 提取数据
extract = F5_out(red_channel, 240);

result_str = ['提取结果为：', bits_to_str(extract)];
disp(result_str)
