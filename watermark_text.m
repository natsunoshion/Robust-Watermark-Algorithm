function watermark_text(text)
    font_size = 26;
    n = floor(sqrt(length(text))) + 1;
    lines = cell(1, n);
    for i = 1:n
        lines{i} = text(((i-1)*n + 1):min(i*n, length(text)));
    end
    
    width = n * font_size;
    height = n * font_size;
    image = ones(height, width, 3, 'uint8') * 255; % 创建白色图像
    font = 'DejaVuSans'; % 使用宋体字体
    position = [10, 10]; % 根据需要进行调整
    textColor = [0 0 0]; % 黑色
    for i = 1:numel(lines)
        textImage = insertText(image, position, lines{i}, ...
            'Font', font, 'FontSize', font_size, 'AnchorPoint', 'LeftTop', ...
            'TextColor', textColor, 'BoxOpacity', 0);
        image = textImage;
        position(2) = position(2) + font_size; % 移动到下一行
    end
    
    imwrite(image, 'watermark.png', 'png');
end