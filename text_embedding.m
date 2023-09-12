% 初始环境
clc
clear
close all

% 要加密的字符串
str = '深圳杯数学建模挑战赛';

% 图片名
filename = 'B题-附件1.jpg';

% 读取原始图像的数据
cover = imread(filename);

% 获取单个通道
red_channel = cover(:,:,1);  % 1896x1280 红色通道

% 将字符串转换为 bit 流
data = str_to_bits(str);

% F5 隐写
modified_red_channel = F5_in(red_channel, data);

% 将修改后的单个通道数据存回原始图像
cover(:,:,1) = modified_red_channel;

imshow(cover);

imwrite(cover, 'SP.png');  % ! 需要使用 PNG 格式，否则会被压缩

disp('嵌入完成');
