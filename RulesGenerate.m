%% Complete set Rules Generation
function Rules=RulesGenerate(MFN,InputsNumber)
    PROD=prod(MFN);
    Repeat=1;
    Rules=nan(PROD,InputsNumber);
    for i=1:InputsNumber
        PROD=PROD/MFN(i);
        for l=1:Repeat
            for k=1:MFN(i)
                for j=1:PROD
                    Rules(j+(k-1)*PROD+(l-1)*PROD*MFN(i),i)=k;
                end
            end
        end
        Repeat=Repeat*MFN(i);
    end
end
    