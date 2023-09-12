function psnr_value = PSNR(original_image, test_image)
    % 计算图像 original_image 和 test_image 的 PSNR
    % 输入参数:
    %   original_image: 原始图像
    %   test_image: 被测试的图像
    % 输出参数:
    %   psnr_value: 计算得到的 PSNR 值

    % 将原始图像和测试图像转为双精度类型
    I1 = double(original_image);
    I2 = double(test_image);

    % 计算误差图像
    E = I1 - I2;

    % 计算均方误差 (MSE)
    MSE = mean2(E .* E);

    if MSE == 0
        psnr_value = -1; % 如果 MSE 为 0，PSNR 为 -1（无穷大）
    else
        % 计算 PSNR 值
        psnr_value = 10 * log10(255 * 255 / MSE);
    end
end
