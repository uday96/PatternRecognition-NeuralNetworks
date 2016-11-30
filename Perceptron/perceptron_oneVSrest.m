% Perceptron Classifier
% One vs Rest
% Linearly Seperable Data

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

N_train = 0;
d = 0;
L_test = 0;
for i = 1:4
    A = importdata(filename_train{i},delimiterIn);
    [N_train,d] = size(A);
    col = ones(N_train,1);
    Datasets_train{i} = [col A(:,1:d)];
    B = importdata(filename_test{i},delimiterIn);
    [N_test,d] = size(B);
    L_test = L_test + N_test;
    col = ones(N_test,1);
    Datasets_test{i} = [col B(:,1:d)];
    C = importdata(filename_val{i},delimiterIn);
    [N_val,d] = size(C);
    col = ones(N_val,1);
    Datasets_val{i} = [col C(:,1:d)];
end

Classifiers = cell(2,1);
for i = 1:4
    Classifiers{i} = getWeights(Datasets_train{i},combineData(i,Datasets_train));
end

% Confusion Matrix Plot
global targetmatrix;
targetmatrix = zeros(4,L_test);
global outputmatrix;
outputmatrix = zeros(4,L_test);
global pointer;
pointer = 1;

confusion_matrix = zeros(4);
total_test_pts = 0;
for i = 1:4
    dataset_test = Datasets_test{i};
    [l_test,~] = size(dataset_test);
    total_test_pts = total_test_pts + l_test;
    actualclass = zeros(4,1);
    actualclass(i) = 1;
    for j = 1:l_test
        X = dataset_test(j,:);
        outputmatrix(:,pointer) = actualclass;
        confusion_matrix(i,:) = confusion_matrix(i,:) + assign_class(X,Classifiers,i,Datasets_val);
    end
end
Accuracy = trace(confusion_matrix)/total_test_pts;
confusion_matrix
fprintf('Classification Accuracy on test data %f\n',Accuracy);

figure();
plotconfusion(targetmatrix,outputmatrix);

% figure();
% % Decision Region Plot
% X_Plot_range = -15:.1:20;
% Y_Plot_range = -15:.1:20;
% [X_plot,Y_plot] = meshgrid(X_Plot_range,Y_Plot_range);
% [plot_n,~] = size(X_plot(:));
% mesh_xy = [ones(plot_n,1) X_plot(:) Y_plot(:)];
% 
% hold on;
% 
% for i=1:length(mesh_xy)
%    X=mesh_xy(i,1:3);
%    classassigns = assign_class(X,Classifiers);
%    [~,classlabel] = max(classassigns);
%    switch(classlabel)
%      case 1
%         plot(mesh_xy(i,2),mesh_xy(i,3) ,'ys','MarkerFaceColor','y');
%      case 2
%         plot(mesh_xy(i,2),mesh_xy(i,3) ,'cs','MarkerFaceColor','c');
%      case 3
%         plot(mesh_xy(i,2),mesh_xy(i,3) ,'ws','MarkerFaceColor','w');
%      case 4
%         plot(mesh_xy(i,2),mesh_xy(i,3) ,'gs','MarkerFaceColor','g');
%     end
% end
% 
% choosecolor = {'r';'b';'k';'m';};
% for i=1:4
%      plot(Datasets_train{i}(:,2),Datasets_train{i}(:,3), '.','color',choosecolor{i});
% end
% title('Decision region plot');
% ylim=get(gca,'ylim');
% xlim=get(gca,'xlim');
% text(xlim(2)-3,ylim(2)-6.5,{'Actual: ',...
%     '{\color{red} o } class1', '{\color{blue} o } class2', '{\color{black} o } class3', '{\color{magenta} o } class4',...
%     '','Predicted: ',...
%     '{\color{yellow} o } class1', '{\color{cyan} o } class2', '{\color{white} o } class3', '{\color{green} o } class4'}, ...
%     'EdgeColor', 'k','BackgroundColor','w');

function classassign = assign_class(X,Weights,actualClasslabel,Datasets_val)
    global targetmatrix;
    global pointer;
    classassign = zeros(1,4);
    numassigns = zeros(1,4);
    for idx = 1:4
        fx = (Weights{idx}).*X;
        %fprintf('%0.f ',sum(fx));
        if(sum(fx)>0)
            numassigns(idx) = numassigns(idx) + 1;
        end
    end
    predictedclasslabel = predictclasslabel(numassigns,actualClasslabel,Datasets_val,Weights);
    classassign(predictedclasslabel) = classassign(predictedclasslabel) + 1;
    predictedclass = zeros(4,1);
    predictedclass(predictedclasslabel) = 1;
    targetmatrix(:,pointer) = predictedclass;
    pointer = pointer + 1;
end

function w_init = getWeights(Dataset1,Dataset2)
    A = [Dataset1;Dataset2];
    [N_train,D] = size(A);
    w_init = zeros(1,D);
    [N_lim,~] = size(Dataset1);
    desiredop = [ones(N_lim,1);zeros((N_train-N_lim),1)];
    while(1)
        predictedop = zeros(N_train,1);
        for i = 1:N_train
            fx = w_init.*A(i,:);
            if(sum(fx)>0)
                predictedop(i) = 1;
            end
            w_init = w_init + (desiredop(i)-predictedop(i)).*A(i,:);
        end
        loopcheck = mean((desiredop - predictedop));
        %disp(loopcheck);
        if(loopcheck == 0)
            break;
        end
    end
end

function data = combineData(exceptclass,Datasets_train)
    data = [];
    for i = 1:4
        if(~(i==exceptclass))
            data = [data;Datasets_train{i}];
        end
    end
end

function predictedclasslabel = predictclasslabel(numassigns,actualClasslabel,Datasets_val,Weights)
    ambiguousclasses = [];
    [~,l_numassigns] = size(numassigns);
    for i = 1:l_numassigns
        if(numassigns(i)==1)
            ambiguousclasses = [ambiguousclasses i];
        end
    end
    [~,l_amb] = size(ambiguousclasses);
    if(l_amb == 1)
        [~,predictedclasslabel] = max(numassigns);
    else
        scores = zeros(1,l_amb);
        valdata = Datasets_val{actualClasslabel};
        [l_val,~] = size(valdata);
        for i = 1:l_amb
            weights = Weights{ambiguousclasses(i)};
            correcthits = 0;
            for j = 1:l_val
                X = valdata(j,:);
                fx = (weights).*X;
                if(sum(fx)>0)
                    correcthits = correcthits + 1;
                end
            end
            acc = correcthits/l_val;
            scores(i) = acc;
        end
        scores
        [~,ind] = max(scores);
        predictedclasslabel = ambiguousclasses(ind);
    end
end