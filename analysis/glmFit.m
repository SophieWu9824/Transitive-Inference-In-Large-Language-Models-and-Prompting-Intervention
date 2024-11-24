
% load("TI_resultTable")
model_i=1;
llm_y = table2array(TI_resultTable(:,7:10));
TIanswer = llm_y(:,model_i);
contxt = TI_resultTable.Context;
order = TI_resultTable.TraOrd;
trial = TI_resultTable.SymDis>0;
tbl = table(order,trial,contxt,TIanswer);
glme = fitglme(tbl,"TIanswer~order+(order|trial)",Distribution="Binomial");
[~,~,statsFixed] = fixedEffects(glme);
[~,~,statsRandom] = randomEffects(glme);
