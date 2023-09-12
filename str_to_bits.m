function msg_bits = str_to_bits(msg_str)
    msg_bin = de2bi(unicode2native(msg_str), 8, 'left-msb');
    len = size(msg_bin, 1) * size(msg_bin, 2);
    msg_bits = reshape(double(msg_bin).', len, 1).';

    % 检查长度能否被 3 整除，不能的话补齐
    if mod(len, 3) == 2
        msg_bits = [msg_bits, 0];
    elseif mod(len, 3) == 1
        msg_bits = [msg_bits, 0, 0];
    end
end
