function Z = getPCA(img1,numb)
     meanVector = mean(img1);
     for i=1:numb
         img1(i,:) = img1(i,:)-meanVector;
     end
     img1cov = cov(img1);
    [U,S,~] = svd(img1cov);
    den = trace(S);
    num=0;
    for i=1:48
        num=num+S(i,i);
        if num/den >=0.999
            break
        end
    end
    k=i;
    URed = U(:,1:k);
    Z = URed'*img1'; 
    Z=Z';
end