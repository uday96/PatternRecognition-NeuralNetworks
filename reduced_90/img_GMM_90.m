All_img_data = random_GMM_plot();
[Probs{1},Datasets_train{1},Datasets_test{1}, Datasets_val{1}] = All_img_data.imgset2 ;
[Probs{2},Datasets_train{2},Datasets_test{2}, Datasets_val{2}] = All_img_data.imgset5 ;
[Probs{3},Datasets_train{3},Datasets_test{3}, Datasets_val{3}] = All_img_data.imgset10 ;
[Probs{4},Datasets_train{4},Datasets_test{4}, Datasets_val{4}] = All_img_data.imgset16 ;
[Probs{5},Datasets_train{5},Datasets_test{5}, Datasets_val{5}] = All_img_data.imgset20 ;

[~,dim] = size(Datasets_train{1});

testFinal = [];
valFinal = [];
for i = 1:5
    testFinal = [testFinal;Datasets_test{i}];
    valFinal = [valFinal;Datasets_val{i}];
end

len=size(valFinal);
len = len(1,1);
targets = zeros(5,len);
for i=1:size(Datasets_test{1})
    targets(1,i)=1;
end
j=i;
for i=j+1:j+size(Datasets_test{2})
    targets(2,i)=1;
end
j=i;
for i=j+1:j+size(Datasets_test{3})
    targets(3,i)=1;
end
j=i;
for i=j+1:j+size(Datasets_test{4})
    targets(4,i)=1;
end
j=i;
for i=j+1:j+size(Datasets_test{5})
    targets(5,i)=1;
end
j=i;

disp(len)
Accur1 = zeros(1,32);
for k=1:32
    p =zeros(len,5);
    obj1 = gmdistribution.fit(Datasets_train{1}(:,1:dim-1),k,'Regularize',0.000001);
    obj2 = gmdistribution.fit(Datasets_train{2}(:,1:dim-1),k,'Regularize',0.000001);
    obj3 = gmdistribution.fit(Datasets_train{3}(:,1:dim-1),k,'Regularize',0.000001);
    obj4 = gmdistribution.fit(Datasets_train{4}(:,1:dim-1),k,'Regularize',0.000001);
    obj5 = gmdistribution.fit(Datasets_train{5}(:,1:dim-1),k,'Regularize',0.000001);
    p(:,1) = pdf(obj1,valFinal(:,1:dim-1));
    p(:,2) = pdf(obj2,valFinal(:,1:dim-1));
    p(:,3) = pdf(obj3,valFinal(:,1:dim-1));
    p(:,4) = pdf(obj4,valFinal(:,1:dim-1));
    p(:,5) = pdf(obj5,valFinal(:,1:dim-1));
    maxprob = zeros(len,1);
    for i=1:len
        [~,maxprob(i,1)] = max(p(i,:));
        if maxprob(i,1)== valFinal(i,dim)
            Accur1(k)=Accur1(k)+1;
        end
    end
    Accur1(k) = Accur1(k)/len;
end
X = zeros(1,32);
for i=1:32
    X(1,i) = i;
end
AccuracyValue=0;
[minVal,minInd]=max(Accur1);
k=minInd;
[len,~] = size(testFinal);
p =zeros(len,5);
obj1 = gmdistribution.fit(Datasets_train{1}(:,1:dim-1),k,'Regularize',0.000001);
obj2 = gmdistribution.fit(Datasets_train{2}(:,1:dim-1),k,'Regularize',0.000001);
obj3 = gmdistribution.fit(Datasets_train{3}(:,1:dim-1),k,'Regularize',0.000001);
obj4 = gmdistribution.fit(Datasets_train{4}(:,1:dim-1),k,'Regularize',0.000001);
obj5 = gmdistribution.fit(Datasets_train{5}(:,1:dim-1),k,'Regularize',0.000001);
p(:,1) = pdf(obj1,testFinal(:,1:dim-1));
p(:,2) = pdf(obj2,testFinal(:,1:dim-1));
p(:,3) = pdf(obj3,testFinal(:,1:dim-1));
p(:,4) = pdf(obj4,testFinal(:,1:dim-1));
p(:,5) = pdf(obj5,testFinal(:,1:dim-1));
maxprob = zeros(len,1);
outputs = zeros(5,len);
for i=1:len
    [~,maxprob(i,1)] = max(p(i,:));
    if maxprob(i,1)== testFinal(i,dim)
        AccuracyValue=AccuracyValue+1;
    end
    outputs(maxprob(i,1),i)=1;
end

AccuracyValue= AccuracyValue/len;

AccuracyValue1=0;
k=13;
[len,~] = size(testFinal);
p =zeros(len,5);
obj1 = gmdistribution.fit(Datasets_train{1}(:,1:dim-1),k,'Regularize',0.000001);
obj2 = gmdistribution.fit(Datasets_train{2}(:,1:dim-1),k,'Regularize',0.000001);
obj3 = gmdistribution.fit(Datasets_train{3}(:,1:dim-1),k,'Regularize',0.000001);
obj4 = gmdistribution.fit(Datasets_train{4}(:,1:dim-1),k,'Regularize',0.000001);
obj5 = gmdistribution.fit(Datasets_train{5}(:,1:dim-1),k,'Regularize',0.000001);
p(:,1) = pdf(obj1,testFinal(:,1:dim-1));
p(:,2) = pdf(obj2,testFinal(:,1:dim-1));
p(:,3) = pdf(obj3,testFinal(:,1:dim-1));
p(:,4) = pdf(obj4,testFinal(:,1:dim-1));
p(:,5) = pdf(obj5,testFinal(:,1:dim-1));
maxprob = zeros(len,1);
for i=1:len
    [~,maxprob(i,1)] = max(p(i,:));
    if maxprob(i,1)== testFinal(i,dim)
        AccuracyValue1=AccuracyValue1+1;
    end
end

AccuracyValue1 = AccuracyValue1/len;
figure() 
plotconfusion(targets,outputs);
title('Confusion Matrix : Test Data');
figure()
plot(X,Accur1);
title('Num of Clusters vs Accuracy');
xlabel('Number of Clusters');
ylabel('Accuracy');

function [imgdata_struct] = random_GMM_plot()
%     rng('default');
    
    load('reducedData_90.mat');

    imgdata_2 = Datasets_reduced{1};
    l2=length(imgdata_2);
    imgdata_5 = Datasets_reduced{2};
    l5=length(imgdata_5);
    imgdata_10 = Datasets_reduced{3};
    l10=length(imgdata_10);
    imgdata_16 = Datasets_reduced{4};
    l16=length(imgdata_16);
    imgdata_20 = Datasets_reduced{5};
    l20=length(imgdata_20);
    
    L = (l2+l5+l10+l16+l20);

    imgdata_2 = standardise(imgdata_2);
    imgdata_5 = standardise(imgdata_5);
    imgdata_10 = standardise(imgdata_10);
    imgdata_16 = standardise(imgdata_16); 
    imgdata_20 = standardise(imgdata_20);
    
    classlab = cell(2,1);
    Lens = {l2,l5,l10,l16,l20};
    for i = 1:5
        classlab{i} = zeros(Lens{i},1);
        classlab{i} = classlab{i} + i;
    end
    
    imgdata_2 = [imgdata_2 classlab{1}];
    imgdata_5 = [imgdata_5 classlab{2}];
    imgdata_10 = [imgdata_10 classlab{3}];
    imgdata_16 = [imgdata_16 classlab{4}];
    imgdata_20 = [imgdata_20 classlab{5}];
    
%     rng(1);
    randomseq_2=randperm(l2);
%     rng(1);
    randomseq_5=randperm(l5);
%     rng(1);
    randomseq_10=randperm(l10);
%     rng(1);
    randomseq_16=randperm(l16);
%     rng(1);
    randomseq_20=randperm(l20);

    prior_prob_2=l2/L;
    prior_prob_5=l5/L;
    prior_prob_10=l10/L;
    prior_prob_16=l16/L;
    prior_prob_20=l20/L;
    
    imgset2_train = [];
    imgset2_test = [];
    imgset2_val = [];
    delimiter = floor((70/100)*l2); 
    delimiter1 = floor((l2-delimiter)/2); 
    for index = 1:delimiter 
        row_number = randomseq_2(index);
        imgset2_train = [imgset2_train; imgdata_2(row_number,:)];
    end
    for index = (delimiter+1):(delimiter+delimiter1)
         row_number = randomseq_2(index);
         imgset2_val = [imgset2_val; imgdata_2(row_number,:)];
    end
     
     for index = (delimiter+1+delimiter1):delimiter+(2*delimiter1)
         row_number = randomseq_2(index);
         imgset2_test = [imgset2_test; imgdata_2(row_number,:)];
     end

    imgset5_train = [];
    imgset5_test = [];
    imgset5_val = [];
    delimiter = floor((70/100)*l5); 
    delimiter1 = floor((l5-delimiter)/2); 
    for index = 1:delimiter 
        row_number = randomseq_5(index);
        imgset5_train = [imgset5_train; imgdata_5(row_number,:)];
    end
    for index = (delimiter+1):(delimiter+delimiter1)
         row_number = randomseq_5(index);
         imgset5_val = [imgset5_val; imgdata_5(row_number,:)];
     end
     for index = (delimiter+1+delimiter1):delimiter+(2*delimiter1)
         row_number = randomseq_5(index);
         imgset5_test = [imgset5_test; imgdata_5(row_number,:)];
     end

    imgset10_train = [];
    imgset10_test = [];
    imgset10_val = [];
    delimiter = floor((70/100)*l10); 
    delimiter1 = floor((l10-delimiter)/2); 
    for index = 1:delimiter 
        row_number = randomseq_10(index);
        imgset10_train = [imgset10_train; imgdata_10(row_number,:)];
    end
    for index = (delimiter+1):(delimiter+delimiter1)
         row_number = randomseq_10(index);
         imgset10_val = [imgset10_val; imgdata_10(row_number,:)];
     end
     for index = (delimiter+1+delimiter1):delimiter+(2*delimiter1)
         row_number = randomseq_10(index);
         imgset10_test = [imgset10_test; imgdata_10(row_number,:)];
     end

    imgset16_train = [];
    imgset16_test = [];
    imgset16_val = [];
    delimiter = floor((70/100)*l16); 
    delimiter1 = floor((l16-delimiter)/2); 
    for index = 1:delimiter 
        row_number = randomseq_16(index);
        imgset16_train = [imgset16_train; imgdata_16(row_number,:)];
    end
    for index = (delimiter+1):(delimiter+delimiter1)
         row_number = randomseq_16(index);
         imgset16_val = [imgset16_val; imgdata_16(row_number,:)];
     end
     for index = (delimiter+1+delimiter1):delimiter+(2*delimiter1)
         row_number = randomseq_16(index);
         imgset16_test = [imgset16_test; imgdata_16(row_number,:)];
     end

    imgset20_train = [];
    imgset20_test = [];
    imgset20_val = [];
    delimiter = floor((70/100)*l20); 
    delimiter1 = floor((l20-delimiter)/2); 
    for index = 1:delimiter 
        row_number = randomseq_20(index);
        imgset20_train = [imgset20_train; imgdata_20(row_number,:)];
    end
    for index = (delimiter+1):(delimiter+delimiter1)
         row_number = randomseq_20(index);
         imgset20_val = [imgset20_val; imgdata_20(row_number,:)];
     end
     for index = (delimiter+1+delimiter1):delimiter+(2*delimiter1)
         row_number = randomseq_20(index);
         imgset20_test = [imgset20_test; imgdata_20(row_number,:)];
     end
    
    field_2 = 'imgset2';
    values_2 = {prior_prob_2; imgset2_train; imgset2_test; imgset2_val};
    field_5 = 'imgset5';
    values_5 = {prior_prob_5; imgset5_train; imgset5_test; imgset5_val};
    field_10 = 'imgset10';
    values_10 = {prior_prob_10; imgset10_train; imgset10_test; imgset10_val};
    field_16 = 'imgset16';
    values_16 = {prior_prob_16; imgset16_train; imgset16_test; imgset16_val};
    field_20 = 'imgset20';
    values_20 = {prior_prob_20; imgset20_train; imgset20_test; imgset20_val};
    
    imgdata_struct = struct(field_2,values_2,field_5,values_5,field_10,values_10,field_16,values_16,field_20,values_20);
end