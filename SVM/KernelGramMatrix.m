addr = 'G:\Acads\5th Sem\PR\Ass2\Dataset1\linearly_seperable_data';
delimiterIn = ' ';

Datasets_train = cell(2,1);
Datasets_test = cell(2,1);
Datasets_val = cell(2,1);

trainfiles = {'class1_train.txt','class2_train.txt','class3_train.txt','class4_train.txt'};
testfiles = {'class1_test.txt','class2_test.txt','class3_test.txt','class4_test.txt'};
valfiles = {'class1_val.txt','class2_val.txt','class3_val.txt','class4_val.txt'};
filename_train = fullfile(addr,trainfiles);
filename_test = fullfile(addr,testfiles);
filename_val = fullfile(addr,valfiles);

DatasetsTraincombined = [];
for i = 1:4
    Datasets_train{i} = importdata(filename_train{i},delimiterIn);
    DatasetsTraincombined = [DatasetsTraincombined; Datasets_train{i}];
    Datasets_test{i} = importdata(filename_test{i},delimiterIn);
    Datasets_val{i} = importdata(filename_val{i},delimiterIn);
end

[len,~] = size(DatasetsTraincombined);
gamma = 40;
KernelGramMat = zeros(len,len);
for m = 1:len
    A = DatasetsTraincombined(m,:);
    for n = 1:len
        B = DatasetsTraincombined(n,:);
        dist = (norm(A-B))^2;
        K_val = exp(-gamma*dist);
        KernelGramMat(m,n) = K_val;
    end
end

figure();
hold on;
for i=1:1000
    for j = 1:1000
        val = KernelGramMat(1000-j+1,i);
        switch(val)
         case 0
            plot(i,j,'MarkerSize',10,'MarkerFaceColor','w');
         case 1
            plot(i,j,'MarkerSize',10,'MarkerFaceColor','k');
         otherwise
             plot(i,j,'MarkerSize',10,'MarkerFaceColor',[0.17,0.17,0.17]);
        end
    end
end