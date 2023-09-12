function transformed_image = arnold_transform(image, iterations)
    array = image;
    [height, width, ~] = size(array);
    scrambled_array = uint8(zeros(size(array)));
    
    for k = 1:iterations
        for y = 1:height
            for x = 1:width
                scrambled_array(x, y, :) = array(mod(x + y - 2, height) + 1, mod(x + 2 * y - 3, width) + 1, :);
            end
        end
        array = scrambled_array;
    end
    
    transformed_image = uint8(array);
end