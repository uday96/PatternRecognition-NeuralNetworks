function [imgdata_struct] = random_GMM()
%     rng('default');
    
    load('reducedData_99.mat');

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
    fprintf('%0.f %0.f\n',delimiter,delimiter1);
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