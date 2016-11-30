function reduced_dataset = PCA(dataset)
    [~,dim] = size(dataset);
    Sigma = cov(dataset);
    [U,S,~] = svd(Sigma);
    
    %Choose reduced_dim
    plot_var_retained = zeros(dim,2);
    for k = 1:dim
        sum_k = 0;
        for i = 1:k
            sum_k = sum_k + S(i,i);
        end
        sum_dim = trace(S);
        var_retained = sum_k/sum_dim;
        plot_var_retained(k,:) = [var_retained k];
        if(var_retained >= 0.999)
            break;
        end
    end
    [~,K_order] = sort(plot_var_retained);
    K_sorted = plot_var_retained(K_order,:);
    l_k = length(K_sorted(:,1))/2;
    K_val = K_sorted(l_k,2);
    var_retained_val = K_sorted(l_k,1);
    reduced_dim = K_val;
    fprintf('Reduced Dimensions : %.0f\n',K_val);
    fprintf('Variance Retained : %f\n\n',var_retained_val);
    U_reduce = U(:,1:reduced_dim);
    reduced_dataset = ((U_reduce')*(dataset'))';
end