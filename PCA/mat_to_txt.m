load('reducedData.mat');
filenames = {'class1_48.txt','class2_48.txt','class3_48.txt','class4_48.txt','class5_48.txt'};
formatspec = '%f';
for j = 1:47
    formatspec = strcat(formatspec,' %f');
end
formatspec = strcat(formatspec,'\n');
for idx = 1:5
    A = Datasets{idx};
    [N,d] = size(A);
    f = fopen(filenames{idx},'w');
    for i = 1:N
        fprintf(f,formatspec,A(i,:));
    end
    fclose(f);
end

load('reducedData_95.mat');
filenames = {'class1_11.txt','class2_11.txt','class3_11.txt','class4_11.txt','class5_11.txt'};
formatspec = '%f';
for j = 1:10
    formatspec = strcat(formatspec,' %f');
end
formatspec = strcat(formatspec,'\n');
for idx = 1:5
    A = Datasets_reduced{idx};
    [N,d] = size(A);
    f = fopen(filenames{idx},'w');
    for i = 1:N
        fprintf(f,formatspec,A(i,:));
    end
    fclose(f);
end

load('reducedData_99.mat');
filenames = {'class1_27.txt','class2_27.txt','class3_27.txt','class4_27.txt','class5_27.txt'};
formatspec = '%f';
for j = 1:26
    formatspec = strcat(formatspec,' %f');
end
formatspec = strcat(formatspec,'\n');
for idx = 1:5
    A = Datasets_reduced{idx};
    [N,d] = size(A);
    f = fopen(filenames{idx},'w');
    for i = 1:N
        fprintf(f,formatspec,A(i,:));
    end
    fclose(f);
end

load('reducedData_90.mat');
filenames = {'class1_5.txt','class2_5.txt','class3_5.txt','class4_5.txt','class5_5.txt'};
formatspec = '%f';
for j = 1:4
    formatspec = strcat(formatspec,' %f');
end
formatspec = strcat(formatspec,'\n');
for idx = 1:5
    A = Datasets_reduced{idx};
    [N,d] = size(A);
    f = fopen(filenames{idx},'w');
    for i = 1:N
        fprintf(f,formatspec,A(i,:));
    end
    fclose(f);
end