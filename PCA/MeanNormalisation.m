function class_dataset_std = MeanNormalisation(class_dataset)
    [rows,cols] = size(class_dataset);
    class_dataset_std = zeros(rows,cols);
    for co = 1:cols
        arr = class_dataset(:,co);
        Mu = mean(arr);
        for ro = 1:rows
            x = class_dataset(ro,co);
            std_val = (x-Mu);
            class_dataset_std(ro,co) = std_val;
        end
    end        
end