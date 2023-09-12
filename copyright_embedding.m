% 初始环境
clc
clear
close all

% 打开文件并获取文件标识符
fileID = fopen('copyright.txt', 'r');

% 逐行读取文件内容并存储到字符串数组中
lines = {};
while ~feof(fileID)
    line = fgetl(fileID);
    lines = [lines; line];
end

% 关闭文件
fclose(fileID);

% 将字符串数组合并为单个字符串，并用换行符连接每行
fileString = strjoin(lines, newline);

data = str_to_bits(fileString);

% 图片名
filename = 'B题-附件1.jpg';

% 读取原始图像的数据
cover = imread(filename);

% 获取通道
red_channel = cover(:,:,1);  % 1896x1280 红色通道
green_channel = cover(:,:,2);  % 1896x1280 绿色通道

% 红通道上的 F5 隐写
modified_red_channel = F5_in(red_channel, data);
cover(:,:,1) = modified_red_channel;
extract_part1 = F5_out(modified_red_channel, length(data));  % 主要是为了统计单个通道能存储的数据大小

% 单个通道容量不够，需要将密文存储在两个通道中
data_part1 = data(1:length(extract_part1));
data_part2 = data(length(extract_part1)+1:end);

% 绿通道上的 F5 隐写
modified_green_channel = F5_in(green_channel, data_part2);
cover(:,:,2) = modified_green_channel;
extract_part2 = F5_out(modified_green_channel, length(data_part2));

info = sprintf('两个通道分别存储 %d 和 %d 个比特', length(extract_part1), length(extract_part2));
disp(info);

imshow(cover);

imwrite(cover, 'SP_copyright.png');

disp('嵌入完成');

% % 与原始数据进行对比
% if isequal(data_part1, extract_part1)
%     disp("嵌入的数据与提取的数据完全一致");
% else
%     disp("结果不一致");
%     disp(length(data_part1));
%     disp(length(extract_part1));
%     % 找到结果有差异的下标索引
%     xor_result = xor(data_part1, extract_part1);
%     nonzero_indices = find(xor_result);
%     disp(nonzero_indices');
% end
% 
% if isequal(data_part2, extract_part2)
%     disp("嵌入的数据与提取的数据完全一致");
% else
%     disp("结果不一致");
%     disp(length(data_part2));
%     disp(length(extract_part2));
%     % 找到结果有差异的下标索引
%     xor_result = xor(data_part2, extract_part2);
%     nonzero_indices = find(xor_result);
%     disp(nonzero_indices');
% end
