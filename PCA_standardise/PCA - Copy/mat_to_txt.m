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
filenames = {'class1_33.txt','class2_33.txt','class3_33.txt','class4_33.txt','class5_33.txt'};
formatspec = '%f';
for j = 1:32
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
filenames = {'class1_43.txt','class2_43.txt','class3_43.txt','class4_43.txt','class5_43.txt'};
formatspec = '%f';
for j = 1:42
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
filenames = {'class1_26.txt','class2_26.txt','class3_26.txt','class4_26.txt','class5_26.txt'};
formatspec = '%f';
for j = 1:25
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