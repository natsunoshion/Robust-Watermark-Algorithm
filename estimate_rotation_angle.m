function angle = estimate_rotation_angle(image)
    % 转换为灰度图像
    gray_image = rgb2gray(image);
    
    % 使用Canny算子提取边缘
    edge_image = edge(gray_image, 'Canny');
    
    % 使用Hough变换检测直线，返回极坐标系中的直线参数
    [H, theta, rho] = hough(edge_image);
    
    % 找到最显著的直线（即Hough变换中的峰值）
    peaks = houghpeaks(H, 1);
    
    % 获取倾斜角度
    angle = theta(peaks(1, 2));
    
    % 将角度转换为弧度
    angle_radians = deg2rad(angle);
    
    % 旋转图像以校正倾斜
    rotated_image = imrotate(image, -angle, 'bilinear', 'crop');
    
    % 显示原始图像、边缘图像、检测到的直线和校正后的图像
    figure;
    imshow(imadjust(mat2gray(H)), 'XData', theta, 'YData', rho), title('Hough变换');
    xlabel('\theta'), ylabel('\rho');
    axis on, axis normal;
    hold on;
    plot(theta(peaks(1, 2)), rho(peaks(1, 1)), 's', 'color', 'white');
    hold off;

    % 显示校正角度
    fprintf('检测到的倾斜角度：%f 度\n', angle);

    % % 对图像进行适当的调整
    % adjusted_H = imadjust(mat2gray(H));
    % 
    % % 创建图像窗口
    % figure;
    % imshow(adjusted_H, 'XData', theta, 'YData', rho);
    % title('Hough变换');
    % 
    % 保存图像到文件
    saveas(gcf, 'Hough.png');

    % 关闭图像窗口
    close(gcf);
    
    % 返回校正角度
    angle = -angle; % 返回负值，使得顺时针旋转为正
end
