function [clusters] = kmeansclustering_realworld(q,dataset)
    %step1: randomly select q vectors
        
    [n,dim]=size(dataset); 
    initial_clusters = datasample(dataset,q,'Replace',false);
    pts_not_assigned_to_clusters = setdiff(dataset,initial_clusters,'rows');
    means = initial_clusters;
    fields = (1:1:q);
    values = cell(1,q);
    clusters = containers.Map(fields, values);
    for i = 1:q
        clusters(i) = [clusters(i); initial_clusters(i,:)];
    end
    for i = 1:(n-q)
        X = pts_not_assigned_to_clusters(i,:);
        distance_from_cluster_means = zeros(1,q);
        for j = 1:q
            Mean = means(j,:);
            distance_from_cluster_means(j) = eucdist(X,Mean);
        end
        [~,ind] = min(distance_from_cluster_means);
        clusters(ind) = [clusters(ind); X];
    end
    new_means = zeros(q,dim);
    for i = 1:q
        new_means(i,:) = mean(clusters(i));
    end
        
    flag = 1;
    count = 200;
    while(flag & count >0 )
        old_means = new_means;
        fields = (1:1:q);
        values = cell(1,q);
        clusters = containers.Map(fields, values);
        for i = 1:n
            X = dataset(i,:);
            distance_from_cluster_means = zeros(1,q);
            for j = 1:q
                Mean = old_means(j,:);
                distance_from_cluster_means(j) = eucdist(X,Mean);
            end
            [~,ind] = min(distance_from_cluster_means);
            clusters(ind) = [clusters(ind); X];
        end
        new_means = zeros(q,dim);
        for i = 1:q
            new_means(i,:) = mean(clusters(i));
        end
        %disp(new_means);
        if(isempty(setdiff(old_means,new_means)))
            flag = 0;
        end
        count = count - 1;
    end
    disp('----------------------- Kmeans end');
end

function d = eucdist(X,Mean)
    x1 = X(1); y1 = X(2);
    x2 = Mean(1); y2 = Mean(2);
	d = sqrt(((x2-x1)^2)+((y2-y1)^2));
end