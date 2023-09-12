function restored_image = arnold_inverse(image, iterations)
    array = uint8(image);
    [height, width, ~] = size(array);
    original_array = uint8(zeros(size(array)));
    
    for k = 1:iterations
        for y = 1:height
            for x = 1:width
                original_array(mod(x + y - 2, height) + 1, mod(x + 2 * y - 3, width) + 1, :) = array(x, y, :);
            end
        end
        array = original_array;
    end
    
    restored_image = uint8(array);
end