% Multi Layer Feed Forward Neural Network
% Image Dataset

Datasets_train = cell(2,1);
Datasets_test = cell(2,1);
Datasets_val = cell(2,1);
    
All_img_data = random();
[Datasets_train{1},Datasets_test{1}, Datasets_val{1}] = All_img_data.imgset2 ;
[Datasets_train{2},Datasets_test{2}, Datasets_val{2}] = All_img_data.imgset5 ;
[Datasets_train{3},Datasets_test{3}, Datasets_val{3}] = All_img_data.imgset10 ;
[Datasets_train{4},Datasets_test{4}, Datasets_val{4}] = All_img_data.imgset16 ;
[Datasets_train{5},Datasets_test{5}, Datasets_val{5}] = All_img_data.imgset20 ;

N_train = cell(2,1);
N_test = cell(2,1);
N_val = cell(2,1);

N_tot = 0;
N_train_tot = 0;
N_test_tot = 0;
N_val_tot = 0;
for i = 1:5
    [N_train{i},d] = size(Datasets_train{i});
    N_train_tot = N_train_tot + N_train{i};
    [N_test{i},~] = size(Datasets_test{i});
    N_test_tot = N_test_tot + N_test{i};
    [N_val{i},~] = size(Datasets_val{i});
    N_val_tot = N_val_tot + N_val{i};
end

N_tot = N_train_tot + N_test_tot + N_val_tot;
inputs = zeros(d,N_tot);
targets = zeros(5,N_tot);

val_start = N_train_tot;
test_start = N_train_tot + N_val_tot; 
N_loop_train = 0; N_loop_test = 0; N_loop_val = 0;
for i = 1:5
    N_loop_train = N_loop_train + N_train{i};
    N_loop_test = N_loop_test + N_test{i};
    N_loop_val = N_loop_val + N_val{i};
    inputs(:,N_loop_train-N_train{i}+1:N_loop_train) = Datasets_train{i}.' ;
    inputs(:,val_start+N_loop_val-N_val{i}+1:val_start+N_loop_val) = Datasets_val{i}.' ;
    inputs(:,test_start+N_loop_test-N_test{i}+1:test_start+N_loop_test) = Datasets_test{i}.' ;
end

stop = 0;
for idx = 1:5
    stop = stop + N_train{idx};
    for i = stop-N_train{idx}+1:stop
        targets(idx,i) = 1;
    end
end

stop = 0;
for idx = 1:5
    stop = stop + N_val{idx};
    for i = val_start+stop-N_val{idx}+1:val_start+stop
        targets(idx,i) = 1;
    end
end

stop = 0;
for idx = 1:5
    stop = stop + N_test{idx};
    for i = test_start+stop-N_test{idx}+1:test_start+stop
        targets(idx,i) = 1;
    end
end

field1 = 'train';
value1 = 1:val_start;
field2 = 'val';
value2 = val_start+1:test_start;
field3 = 'test';
value3 = test_start+1:N_tot;
Indices = struct(field1,value1,field2,value2,field3,value3);

MLFFNN_ind(inputs,targets,Indices);