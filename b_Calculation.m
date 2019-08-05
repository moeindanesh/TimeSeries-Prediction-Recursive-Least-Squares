function b_Value=b_Calculation(X,Rules,MFN,MFType,UpperBound,LowerBound)
Mu_Value=nan(size(Rules));
    for i=1:size(Rules,1)
        for j=1:size(Rules,2)
            Mu_Value(i,j)=Mu_Calculation(X(j),Rules(i,j),MFN(j),MFType(j),UpperBound(j),LowerBound(j));
        end
    end
    a=prod(Mu_Value,2);
    b=sum(a);
    b_Value=a/b;
end