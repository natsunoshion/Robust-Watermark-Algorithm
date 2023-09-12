function msg_str = bits_to_str(msg_bits)
    % 保留有效比特流部分
    bit_count = length(msg_bits);
    valid_bit_count = bit_count - mod(bit_count, 8);
    valid_msg_bits = msg_bits(1:valid_bit_count);

    % 将比特流重新整形成矩阵
    msg_bin_matrix = reshape(logical(valid_msg_bits), 8, []).';
    
    % 将二进制矩阵转换回整数向量
    msg_bin_vector = bi2de(msg_bin_matrix, 'left-msb');
    
    % 将整数向量转换为Unicode字符向量
    unicode_vector = native2unicode(msg_bin_vector);
    
    % 将Unicode字符向量转换为字符串
    msg_str = char(unicode_vector)';  % 取转置，在一行输出
end
