function modelComp(variable_pool,TI_resultTable)
% % 1-4: GPT-3.5-Turbo, GPT-4, Llama3-8B, Qwen
%% model: above random level-50%
% GPT-3.5-Turbo
[h,p,ci,tstats]=ttest(eval(strcat("recall.",variable_pool(1)))-0.5);
[h,p,ci,tstats]=ttest(eval(strcat("infer.",variable_pool(1)))-0.5);
% GPT-4
[h,p,ci,tstats]=ttest(eval(strcat("recall.",variable_pool(2)))-0.5);
[h,p,ci,tstats]=ttest(eval(strcat("infer.",variable_pool(2)))-0.5);
% Llama3
[h,p,ci,tstats]=ttest(eval(strcat("recall.",variable_pool(3)))-0.5);
[h,p,ci,tstats]=ttest(eval(strcat("infer.",variable_pool(3)))-0.5);
% Qwen
[h,p,ci,tstats]=ttest(eval(strcat("recall.",variable_pool(4)))-0.5);
[h,p,ci,tstats]=ttest(eval(strcat("infer.",variable_pool(4)))-0.5);





%% recall: model comparison
% % recall
% [h,p,ci,tstats] = ttest(eval(strcat("recall.",variable_pool(1))),...
%     eval(strcat("recall.",variable_pool(2)))); % GPT-3.5 vs. GPT-4
% [h,p,ci,tstats] = ttest(eval(strcat("recall.",variable_pool(1))),...
%     eval(strcat("recall.",variable_pool(3)))); % GPT-3.5 vs. Llama3
% [h,p,ci,tstats] = ttest(eval(strcat("recall.",variable_pool(1))),...
%     eval(strcat("recall.",variable_pool(4)))); % GPT-3.5 vs. Qwen
% [h,p,ci,tstats] = ttest(eval(strcat("recall.",variable_pool(2))),...
%     eval(strcat("recall.",variable_pool(3)))); % GPT-4 vs. Llama3
% [h,p,ci,tstats] = ttest(eval(strcat("recall.",variable_pool(2))),...
%     eval(strcat("recall.",variable_pool(4)))); % GPT-4 vs. Qwen
% [h,p,ci,tstats] = ttest(eval(strcat("recall.",variable_pool(3))),...
%     eval(strcat("recall.",variable_pool(4)))); % Llama3 vs. Qwen

% % 行：不同LLM；列：recall vs infer
% tempTable = TI_resultTable(:,[2,7:10]);
% tempTable = sortrows(tempTable,1);
% data = repmat([zeros(4,1),(1:4)';ones(4,1),(1:4)'],270,1);
% data = sortrows(data,1);data=sortrows(data,2);
% temp = 0;
% for i=1:2 % trial type: 0-recall,1-infer
%     temp_range1 = (1:270)+270*(i-1);
%     for j=1:4 %modeL type
%         temp = temp + 1;
%         temp_range2 = (1:270)+270*(temp-1);
%         data(temp_range2,3)=table2array(tempTable(temp_range1,j+1));
%     end
% end
% data_table = array2table(data,'VariableNames',...
%     {'trialType','ModelType','Accuracy'});
% [p,tb1,stats] = anovan(data_table.Accuracy,{data_table.trialType,data_table.ModelType},...
%     'model','interaction','varnames',{'trialType','ModelType'});
% disp(p);disp(tb1)
% trialComp = multcompare(stats,'Dimension',1);
% modelComp = multcompare(stats,'Dimension',2);

end