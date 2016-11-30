%Dimension Reduction for Image Dataset

addr = 'G:\Acads\5th Sem\PR\Ass2';
filename = fullfile(addr,'CompleteData.mat');

Datasets = cell(2,1);
Datasets_reduced = cell(2,1);
N_datasets = cell(2,1); 

images = load(filename);

Datasets{1} = MeanNormalisation(images.CompleteData{2,1});
Datasets{2} = MeanNormalisation(images.CompleteData{5,1});
Datasets{3} = MeanNormalisation(images.CompleteData{10,1});
Datasets{4} = MeanNormalisation(images.CompleteData{16,1});
Datasets{5} = MeanNormalisation(images.CompleteData{20,1});

N_tot = 0;
dim_org = 0;
All_classes_data =[];
for i = 1:5
    [N_datasets{i},dim_org] = size(Datasets{i});
    N_tot = N_tot + N_datasets{i};
    All_classes_data = [All_classes_data;Datasets{i}];
end

All_classes_data_reduced = PCA(All_classes_data);

start = 1;
stop = 0;
for i = 1:5
    stop = stop + N_datasets{i};
    Datasets_reduced{i} = All_classes_data_reduced(start:stop,:);
    start = stop + 1;
end

save 'reducedData_90.mat';