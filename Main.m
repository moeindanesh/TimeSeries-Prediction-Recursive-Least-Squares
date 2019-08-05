function Main(SIGMA, NDataPairs, SamplesNumber, MFN, MFType)
clc;
tic
%% Parameters

%NonLinearSystem
InputsNumber=1;
LowerBound=[-1 -0.7];
UpperBound=[1 0.7];

%--------------------Fuzzy System Parameters----------
% MFN=6;             % Number of Membership Function on each Input
% MFType=3;           % trimf==>1    trapmf==>2     gaussmf==>3
%InputsNumber=3;     % Number of fuzzy system input
%LowerBound=0.2;      % Inputs Lower Bound
%UpperBound=1.4;       % Inputs Upper Bound
%OutputLB=0.2;        % Output Lower Boundary
%OutputUB=1.4;         % Output Upper Boundary
%% Parameters Initiating
if numel(MFN)~=InputsNumber+1
    if numel(MFN)==1
        MFN=repmat(MFN,1,InputsNumber+1);
    else
        disp('Invalid Membership Function Number!');
        MFN=nan;
    end
end
if numel(LowerBound)~=InputsNumber+1
    if numel(LowerBound)==1
        LowerBound=repmat(LowerBound,1,InputsNumber+1);
    else
        disp('Invalid Lower Boundary!');
        LowerBound=nan;
    end
end
if numel(UpperBound)~=InputsNumber+1
    if numel(UpperBound)==1
        UpperBound=repmat(UpperBound,1,InputsNumber+1);
    else
        disp('Invalid Upper Boundary!');
        UpperBound=nan;
    end
end
if numel(MFType)~=InputsNumber+1
    if numel(MFType)==1
        MFType=repmat(MFType,1,InputsNumber+1);
    else
        disp('Invalid Membership Function Handle!');
        MFType=nan;
    end
end
%% Samples Generation
y_Approx=nan(1,SamplesNumber);

[Samples, Pairs]=NonLinSys(SamplesNumber,NDataPairs);
y_Approx(1:3)=Samples(1:3,end);
%% Rule Generation
Rules=RulesGenerate(MFN(1:end-1),InputsNumber);
%% Output Center Generation

Theta=LowerBound(end):(UpperBound(end)-LowerBound(end))/(size(Rules,1)-1):UpperBound(end);
Theta=Theta';
Color=rand(numel(Theta),3);
%-------------------Plotting Initial Theta------------------------
figure;
subplot(1,2,1);
for i=1:numel(Theta)
    line([Theta(i),Theta(i)],[0,1],'linewidth',2,'color',Color(i,:));
    hold on;
end
hold off;
ylabel('\theta Before Uppdating');
xlim([LowerBound(end) UpperBound(end)]);
%% Recursive Least Squares Computation
P_mat=SIGMA*eye(size(Rules,1));
for p=1:size(Pairs,1)
    b_xp=b_Calculation(Pairs(p,1:end-1),Rules,MFN,MFType,UpperBound,LowerBound);
    K_p=P_mat*b_xp*(1/(b_xp'*P_mat*b_xp+1));
    Theta=Theta+K_p*(Pairs(p,end)-b_xp'*Theta);
    P_mat=P_mat-P_mat*b_xp*(1/(b_xp'*P_mat*b_xp+1))*b_xp'*P_mat;
end
%% Results Calculation
f=nan(1,SamplesNumber);
f(1:2)=Samples(1:2,end)';
for i=2:size(Samples,1)
    b=b_Calculation(Samples(i,1:end-1),Rules,MFN,MFType,UpperBound,LowerBound);
    f(i)=b'*Theta;
                   
    if i~=1 && i~=2 && i~=3
    	y_Approx(i)=0.3*Samples(i-1,end)+0.6*Samples(i-2,end)+f(i-1);
    end
end

%% Plotting Results
%-------------------Plotting Final Theta------------------------
subplot(1,2,2);
for i=1:numel(Theta)
    line([Theta(i),Theta(i)],[0,1],'linewidth',2,'color',Color(i,:));
    hold on;
end
hold off;
ylabel('\theta After Uppdating');
xlim([LowerBound(end) UpperBound(end)]);
%-------------------final Results
figure;
plot(Samples(:,end));
hold on
plot(y_Approx,'r');
legend('Real Vaue','Predicted');
%-------------------Error 
disp('Mean Square Error:')
MSE=mse(Samples(:,end)-y_Approx');
disp(MSE);
disp('Mean Absolute Error:')
MAE=mae(Samples(:,end)-y_Approx');
disp(MAE);
toc