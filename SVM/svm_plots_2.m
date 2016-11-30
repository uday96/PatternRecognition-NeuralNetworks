addr = 'G:\Acads\5th Sem\PR\Ass2';

filename = fullfile(addr,'grid.txt');
data_grid = dlmread(filename);

filename = fullfile(addr,'output1.txt');
data_op1 = dlmread(filename);

filename = fullfile(addr,'output2.txt');
data_op2 = dlmread(filename);

filename = fullfile(addr,'output3.txt');
data_op3 = dlmread(filename);

addr = 'G:\Acads\5th Sem\PR\Ass2\Dataset1\non_linearly_seperable_data';
delimiterIn = ' ';

Datasets_train = cell(2,1);
trainfiles = {'class1_train.txt','class2_train.txt'};
filename_train = fullfile(addr,trainfiles);
for i = 1:2
    Datasets_train{i} = importdata(filename_train{i},delimiterIn);
end

figure();
% Decision Region Plot
[plot_N,~] = size(data_grid);
hold on;

for i=1:plot_N
   X = data_grid(i,:);
   classlabel = data_op2(i,:);
   switch(classlabel)
       case 1
           plot(X(1),X(2) ,'ys','MarkerFaceColor','y');
       case -1
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