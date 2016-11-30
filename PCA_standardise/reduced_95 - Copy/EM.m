function [new_coeff,Means_new,Covar_new] = EM(num_clusters,dataset)
    [clusters] = kmeansclustering_realworld(num_clusters,dataset);
    [N,dim] = size(dataset);
    coeff = zeros(1,num_clusters);
    for i = 1:num_clusters
        [Nq,~] = size(clusters(i));
        coeff(i) = Nq/N ;
    end

    w = zeros(N,num_clusters);
    for n=1:N
        X = dataset(n,:);
        S = 0;
        for q = 1:num_clusters
            S = S + coeff(q)*probdens(X,mean(clusters(q)),dim,get_cov(cov(clusters(q)),dim));
        end
        for q = 1:num_clusters
            w(n,q)=coeff(q)*probdens(X,mean(clusters(q)),dim,get_cov(cov(clusters(q)),dim))/S;
        end
    end

    N_new = 0;
    Nq_new = zeros(1,num_clusters);
    for q=1:num_clusters
        N_tot = 0;
        for i = 1:N
            N_tot = N_tot + w(i,q);
        end
        Nq_new(q) = N_tot;
        N_new = N_new + N_tot;
    end

    new_coeff = zeros(1,num_clusters);
    for q=1:num_clusters
        new_coeff(q)=Nq_new(q)/N_new;
    end

    fields = (1:1:q);
    values = cell(1,q);
    Means_new = containers.Map(fields, values);
    for q=1:num_clusters
        new_avg = zeros(1,dim);
        for i =1:N
            X = dataset(i,: );
            new_avg = new_avg + w(i,q)*X;
        end
        Means_new(q) = new_avg/Nq_new(q);
    end

    fields = (1:1:q);
    values = cell(1,q);
    Covar_new = containers.Map(fields, values);
    for q=1:num_clusters
        new_cov = zeros(dim,dim);
        for i =1:N
            X = dataset(i,: );
            new_cov = new_cov + w(i,q)*(transpose(X-Means_new(q)))*(X-Means_new(q));
        end
        Covar_new(q) = new_cov/Nq_new(q);
        Covar_new(q) = get_cov(Covar_new(q),dim);
    end
    
    PrevLikelihood = getLikelihood(dataset,new_coeff,Means_new,Covar_new);
    %count = 10;
    while(1)
        w = zeros(N,num_clusters);
        for n=1:N
            X = dataset(n,:);
            S = 0;
            for q = 1:num_clusters
                S = S + new_coeff(q)*probdens(X,Means_new(q),dim,Covar_new(q));
            end
            for q = 1:num_clusters
                w(n,q)=(new_coeff(q)*probdens(X,Means_new(q),dim,Covar_new(q)))/S;
            end
        end

        N_new = 0;
        Nq_new = zeros(1,num_clusters);
        for q=1:num_clusters
            N_tot = 0;
            for i = 1:N
                N_tot = N_tot + w(i,q);
            end
            Nq_new(q) = N_tot;
            N_new = N_new + N_tot;
        end

        new_coeff = zeros(1,num_clusters);
        for q=1:num_clusters
            new_coeff(q)=Nq_new(q)/N_new;
        end

        for q=1:num_clusters
            new_avg = zeros(1,dim);
            for i =1:N
                X = dataset(i,: );
                new_avg = new_avg + w(i,q)*X;
            end
            Means_new(q) = new_avg/Nq_new(q);
        end

        for q=1:num_clusters
            new_cov = zeros(dim,dim);
            for i =1:N
                X = dataset(i,: );
                new_cov = new_cov + w(i,q)*(transpose(X-Means_new(q)))*(X-Means_new(q));
            end
            Covar_new(q) = new_cov/Nq_new(q);
            Covar_new(q) = get_cov(Covar_new(q),dim);
        end
        
        NewLikelihood = getLikelihood(dataset,new_coeff,Means_new,Covar_new);
        %disp(PrevLikelihood);
        %disp(NewLikelihood);
        likelidiff = NewLikelihood - PrevLikelihood;
        %disp(likelidiff);
        if( likelidiff < 0.0001 && likelidiff > -0.0001 )
            %disp('----------------');
            break;
        else
            PrevLikelihood = NewLikelihood;
        end
        %count = count - 1;
    end
    disp('----------------------- EM end');
end

function val = probdens(x,Mean,d,CoVarMatrix) 
    %DET = det(CoVarMatrix);
    %val = (1/(((2*pi)^(d/2))*(sqrt(DET))))*(exp(-(x-Mean)*(inv(CoVarMatrix))*(transpose(x-Mean)/2)));
    val = mvnpdf(x,Mean,CoVarMatrix);
end

function cov_matrix = get_cov(matrix,dim)
    cov_matrix = matrix;
    cov_matrix = cov_matrix + eye(dim)*0.000001;
    %disp(det(cov_matrix));
end

function likelihood = getLikelihood(X,Wqs,Means,CoVarMatrixs)
    likelihood = 0.0;
    [N,~] = size(X);
    for i=1:N
        x = X(i,:);
        val = discriminant_func_GMM(x,Wqs,Means,CoVarMatrixs);
        likelihood = likelihood + val;
    end
end

function val = discriminant_func_GMM(x,Wqs,Means,CoVarMatrixs)
   %Bayes || GMM  || diff C 
   Q = size(Means);
   val = 0.0;
   for q = 1:Q
       Mean = Means(q); CoVarMatrix = CoVarMatrixs(q);
       val = val + (Wqs(q)*discriminant_func_GMM_cluster(x,Mean,CoVarMatrix)); 
   end
   val = log(val);
end
function val = discriminant_func_GMM_cluster(x,Mean,CoVarMatrix)
   %Bayes || GMM  || diff C 
   %val = (1/((det(CoVarMatrix))^(1/2)))*(exp(-(x-Mean)*(inv(CoVarMatrix))*(transpose(x-Mean)/2)));
    val = mvnpdf(x,Mean,CoVarMatrix);
end