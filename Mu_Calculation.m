function Value=Mu_Calculation(x,MFNo,MFN,MFType,UpperBound,LowerBound)
switch MFType
    case 1      % Triangular
        Step=(UpperBound-LowerBound)/(MFN-1);
        Center=LowerBound+(MFNo-1)*Step;
        Value=trimf(x,[Center-Step,Center,Center+Step]);
        
    case 2      % Trapezoid
        Step=(UpperBound-LowerBound)/(MFN-1)/3;
        Center=LowerBound+(MFNo-1)*3*Step;
        Value=trapmf(x,[Center-2*Step,Center-Step,Center+Step,Center+2*Step]);        
        
    case 3      % Gaussian
        Step=(UpperBound-LowerBound)/(MFN-1)/2;
        Center=LowerBound+(MFNo-1)*2*Step;
        Value=gaussmf(x,[Step,Center]);
    otherwise
        disp('Selected Membership Function is undefined!')
end
end