% Multi Layer Feed Forward Neural Network
% Non Linearly Seperable Data

addr = 'G:\Acads\5th Sem\PR\Ass2\Dataset1\non_linearly_seperable_data';
delimiterIn = ' ';

Datasets_train = cell(2,1);
Datasets_test = cell(2,1);
Datasets_val = cell(2,1);

trainfiles = {'class1_train.txt','class2_train.txt'};
testfiles = {'class1_test.txt','class2_test.txt'};
valfiles = {'class1_val.txt','class2_val.txt'};
filename_train = fullfile(addr,trainfiles);
filename_test = fullfile(addr,testfiles);
filename_val = fullfile(addr,valfiles);

for i = 1:2
    Datasets_train{i} = importdata(filename_train{i},delimiterIn);
    Datasets_test{i} = importdata(filename_test{i},delimiterIn);
    Datasets_val{i} = importdata(filename_val{i},delimiterIn);
end

[N_train,d] = size(Datasets_train{1});
[N_test,~] = size(Datasets_test{1});
[N_val,~] = size(Datasets_val{1});
N = 2*(N_train + N_test + N_val);
inputs = zeros(d,N);
targets = zeros(2,N);

val_start = 2*N_train;
test_start = 2*(N_train + N_val); 
for i = 1:2
    inputs(:,(i-1)*N_train+1:i*N_train) = Datasets_train{i}.' ;
    inputs(:,val_start+(i-1)*N_val+1:val_start+i*N_val) = Datasets_val{i}.' ;
    inputs(:,test_start+(i-1)*N_test+1:test_start+i*N_test) = Datasets_test{i}.' ;
end
for i=1:N_train
    targets(1,i) = 1;
    targets(2,i+N_train) = 1;
end
for i=1:N_val
    targets(1,i+val_start) = 1;
    targets(2,i+N_val+val_start) = 1;
end
for i=1:N_test
    targets(1,i+test_start) = 1;
    targets(2,i+N_test+test_start) = 1;
end
field1 = 'train';
value1 = 1:val_start;
field2 = 'val';
value2 = val_start+1:test_start;
field3 = 'test';
value3 = test_start+1:N;
Indices = struct(field1,value1,field2,value2,field3,value3);

[net,perf] = MLFFNN_ind(inputs,targets,Indices);

if(perf<0.005)
    figure();
    % Decision Region Plot
    X_Plot_range = -15:.1:20;
    Y_Plot_range = -15:.1:20;
    [X_plot,Y_plot] = meshgrid(X_Plot_range,Y_Plot_range);
    mesh_xy = [X_plot(:) Y_plot(:)];
    plot_inputs = mesh_xy.';
    plot_outputs = net(plot_inputs);
    [~,plot_N] = size(plot_outputs);
    hold on;

    for i=1:plot_N
       X = plot_inputs(:,i);
       [~,classlabel] = max(plot_outputs(:,i));
         switch(classlabel)
             case 1
                plot(X(1),X(2) ,'ys','MarkerFaceColor','y');
             case 2
                plot(X(1),X(2) ,'cs','MarkerFaceColor','c');
         end
    end
    choosecolor = {'r';'b';};
    for i=1:2
         plot(Datasets_train{i}(:,1),Datasets_train{i}(:,2), '.','color',choosecolor{i});
    end
    title('Decision region plot');
    ylim=get(gca,'ylim');
    xlim=get(gca,'xlim');
    text(xlim(2)-3,ylim(2)-4,{'Actual: '...
            '{\color{red} o } class1', '{\color{blue} o } class2',...
            '','Predicted: ',...
            '{\color{yellow} o } class1', '{\color{cyan} o } class2'},...
            'EdgeColor', 'k','BackgroundColor','w');
end