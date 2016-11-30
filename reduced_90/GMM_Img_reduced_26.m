global targetmatrix;
global outputmatrix;
global pointer;
pointer = 1;

num_clusters = 1;

Datasets_train = cell(2,1);
Datasets_test = cell(2,1);
Datasets_val = cell(2,1);

Means = cell(2,1);
Covars = cell(2,1);
Weights = cell(2,1);
Probs = cell(2,1);

accu_val = 0;

fields = (1:1:3);
values = cell(1,3);
ConfusionMatrices = containers.Map(fields, values);
opMatrices = containers.Map(fields, values);
tarMatrices = containers.Map(fields, values);
Params_all = containers.Map(fields, values);
index = 1;
choose_num_cluster = zeros(3,2);
for num_clusters = 3:2:7
    disp('---------------------');
    confusion_matrix=[];
    accu_val = 0.0;
    while(accu_val<0.65)
         All_img_data = random_GMM();
        [Probs{1},Datasets_train{1},Datasets_test{1}, Datasets_val{1}] = All_img_data.imgset2 ;
        [Probs{2},Datasets_train{2},Datasets_test{2}, Datasets_val{2}] = All_img_data.imgset5 ;
        [Probs{3},Datasets_train{3},Datasets_test{3}, Datasets_val{3}] = All_img_data.imgset10 ;
        [Probs{4},Datasets_train{4},Datasets_test{4}, Datasets_val{4}] = All_img_data.imgset16 ;
        [Probs{5},Datasets_train{5},Datasets_test{5}, Datasets_val{5}] = All_img_data.imgset20 ;

        for idx = 1:5
            [Weights{idx},Means{idx},Covars{idx}] = EM(num_clusters,Datasets_train{idx});
        end

        L_val = 0;
        for idx = 1:5
            [l_idx,~] = size(Datasets_val);
            L_val = L_val + l_idx;
        end

        targetmatrix = zeros(5,L_val);
        outputmatrix = zeros(5,L_val);
        pointer = 1;

        confusion_matrix = zeros(5);
        total_hits_test = 0;

        field1 = 'mean';    field2 = 'covariance';  field3 = 'probability';field4 = 'weights';
        values1 = {Means{1};Means{2};Means{3};Means{4};Means{5}};
        values2 = {Covars{1};Covars{2};Covars{3};Covars{4};Covars{5}};
        values3 = [Probs{1} Probs{2} Probs{3} Probs{4} Probs{5}];
        values4 = {Weights{1};Weights{2};Weights{3};Weights{4};Weights{5}};
        Params = struct(field1,values1,field2,values2,field3,values3,field4,values4);

        for idx = 1:5
            confusion_matrix(idx,:) = assign_class(Datasets_val{idx},Params,idx);
            total_hits_test = total_hits_test + sum(confusion_matrix(idx,:));
        end

        total_correct_hits_test = trace(confusion_matrix);
        accu_val = total_correct_hits_test/total_hits_test
    end
    ConfusionMatrices(index) = confusion_matrix;
    opMatrices(index) = outputmatrix;
    tarMatrices(index) = targetmatrix;
    choose_num_clusters(index,:) = [accu_val num_clusters ];
    Params_all(index) = Params;
    index = index + 1;
end
fprintf('Accuracy vs Num_Clusters = \n\n');
disp(choose_num_clusters);

figure();
h = plot(choose_num_clusters(:,2),choose_num_clusters(:,1));
hold on
scatter(choose_num_clusters(:,2),choose_num_clusters(:,1),150,'filled', ...
       'MarkerFaceAlpha',3/8,'MarkerFaceColor',h.Color)         
hold off
title('Num of Clusters vs Accuracy');
xlabel('Number of Clusters');
ylabel('Accuracy');

[~,num_clusters] = sort(choose_num_clusters);
Sorted = choose_num_clusters(num_clusters,:);
l_k = length(Sorted(:,1))/2;
num_clusters = Sorted(l_k,2);
accu_val = Sorted(l_k,1);
fprintf('Number Of Clusters: %f\n',num_clusters);
ConfusionMatrices((num_clusters-1)/2)
fprintf('Classification Accuracy on val data: %f\n',accu_val);

Params = Params_all((num_clusters-1)/2);
op = opMatrices((num_clusters-1)/2);
tar = tarMatrices((num_clusters-1)/2);

figure();
plotconfusion(tar,op);
title('Confusion Matrix : Validation Data');

L_test = 0;
for idx = 1:5
    [l_idx,~] = size(Datasets_test);
    L_test = L_test + l_idx;
end

targetmatrix = zeros(5,L_test);
outputmatrix = zeros(5,L_test);
pointer = 1;
    
confusion_matrix = zeros(5);
total_hits_test = 0;

for idx = 1:5
    confusion_matrix(idx,:) = assign_class(Datasets_test{idx},Params,idx);
    total_hits_test = total_hits_test + sum(confusion_matrix(idx,:));
end

total_correct_hits_test = trace(confusion_matrix);
accuracy_test = total_correct_hits_test/total_hits_test;
confusion_matrix
fprintf('Classification Accuracy on test data: %f\n',accuracy_test);

figure();
plotconfusion(targetmatrix,outputmatrix);
title('Confusion Matrix : Test Data');


function no_of_assignments = assign_class(imgset_test,Params,Actualclasslabel)
    global outputmatrix;
    global targetmatrix;
    global pointer;
    l_test = length(imgset_test(:,1));
    no_of_assignments = zeros(1,5);
    [Means_2,Means_5,Means_10,Means_16,Means_20] = Params.mean;
    [Covar_2,Covar_5,Covar_10,Covar_16,Covar_20] = Params.covariance;
    Probabilities = Params.probability;
    [Wq_2,Wq_5,Wq_10,Wq_16,Wq_20] = Params.weights;
    actualclass = zeros(5,1);
    actualclass(Actualclasslabel) = 1;
    for i = 1:l_test
        outputmatrix(:,pointer) = actualclass;
        disc_val = zeros(1,5);
        X = imgset_test(i,:);
        disc_val(1) = discriminant_func_GMM(X,Wq_2,Means_2,Covar_2,Probabilities(1));
        disc_val(2) = discriminant_func_GMM(X,Wq_5,Means_5,Covar_5,Probabilities(2));
        disc_val(3) = discriminant_func_GMM(X,Wq_10,Means_10,Covar_10,Probabilities(3));
        disc_val(4) = discriminant_func_GMM(X,Wq_16,Means_16,Covar_16,Probabilities(4));
        disc_val(5) = discriminant_func_GMM(X,Wq_20,Means_20,Covar_20,Probabilities(5));
        [~,class_label] = max(disc_val);
        %disp(disc_val);
        no_of_assignments(class_label) = no_of_assignments(class_label) + 1;
        predictedclass = zeros(5,1);
        predictedclass(class_label) = 1;
        targetmatrix(:,pointer) = predictedclass;
        pointer = pointer + 1;
        %fprintf('Assigning class %.0f to (%f,%f)\n',class_label,X(1),X(2));
    end
end        

function val = discriminant_func_GMM(x,Wqs,Means,CoVarMatrixs,Prob)
   %Bayes || diff C 
   Q = size(Means);
   val = 0;
   for q = 1:Q
       Mean = Means(q); CoVarMatrix = CoVarMatrixs(q);
       val = val + (Wqs(q)*discriminant_func_GMM_cluster(x,Mean,CoVarMatrix)); 
   end
   %val = val*Prob;
   val = log(val)+log(Prob);
end
function val = discriminant_func_GMM_cluster(x,Mean,CoVarMatrix)
   %Bayes || diff C 
   %DET = det(CoVarMatrix);
   %val = (1/(sqrt(DET)))*(exp(-(x-Mean)*(inv(CoVarMatrix))*(transpose(x-Mean)/2)));
   val = mvnpdf(x,Mean,CoVarMatrix);
end