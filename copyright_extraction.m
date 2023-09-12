% 初始环境
clc
clear
close all

% 图片名
filename = 'SP_copyright.png';

% 读取生成的压缩图像的数据
cover = imread(filename);

% 获取通道
red_channel = cover(:,:,1);  % 1896x1280 红色通道
green_channel = cover(:,:,2);  % 1896x1280 绿色通道

% 提取结果
extract_part1 = F5_out(red_channel, 179916);
extract_part2 = F5_out(green_channel, 80628);
extract = [extract_part1, extract_part2];
result_str = ['提取结果为：', bits_to_str(extract)];
disp(result_str)
