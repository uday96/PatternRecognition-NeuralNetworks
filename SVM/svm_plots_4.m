addr = 'G:\Acads\5th Sem\PR\Ass2';

filename = fullfile(addr,'grid.txt');
data_grid = dlmread(filename);

filename = fullfile(addr,'output1.txt');
data_op1 = dlmread(filename);

filename = fullfile(addr,'output2.txt');
data_op2 = dlmread(filename);

filename = fullfile(addr,'output3.txt');
data_op3 = dlmread(filename);

addr = 'G:\Acads\5th Sem\PR\Ass2\Dataset1\linearly_seperable_data';
delimiterIn = ' ';

Datasets_train = cell(2,1);
trainfiles = {'class1_train.txt','class2_train.txt','class3_train.txt','class4_train.txt'};
filename_train = fullfile(addr,trainfiles);
for i = 1:4
    Datasets_train{i} = importdata(filename_train{i},delimiterIn);
end

figure();
% Decision Region Plot
[plot_N,~] = size(data_grid);
hold on;

for i=1:plot_N
   X = data_grid(i,:);
   classlabel = data_op3(i,:);
    switch(classlabel)
         case 1
            plot(X(1),X(2) ,'ys','MarkerFaceColor','y');
         case 2
            plot(X(1),X(2) ,'cs','MarkerFaceColor','c');
         case 3
            plot(X(1),X(2) ,'ws','MarkerFaceColor','w');
         case 4
            plot(X(1),X(2) ,'gs','MarkerFaceColor','g');
     end
end

choosecolor = {'r';'b';'k';'m';};
for i=1:4
     plot(Datasets_train{i}(:,1),Datasets_train{i}(:,2), '.','color',choosecolor{i});
end
title('Decision region plot');
ylim=get(gca,'ylim');
xlim=get(gca,'xlim');
text(xlim(2)-3,ylim(2)-6.5,{'Actual: ',...
    '{\color{red} o } class1', '{\color{blue} o } class2', '{\color{black} o } class3', '{\color{magenta} o } class4',...
    '','Predicted: ',...
    '{\color{yellow} o } class1', '{\color{cyan} o } class2', '{\color{white} o } class3', '{\color{green} o } class4'}, ...
    'EdgeColor', 'k','BackgroundColor','w');