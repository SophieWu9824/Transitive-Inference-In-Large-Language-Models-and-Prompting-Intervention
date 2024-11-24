function EndItem_effect(variable_pool,TI_resultTable,model_groups,occasion)
% id for model and promotion method
origin_id = [1,2,3,4];
Prob_id = [5,7,9,11];
CoT_id = [6,8,10,12];
title_pool = {"","Confidence","Chain-of-Thought"};
switch occasion
    case 1
        name_id = origin_id;
    case 2
        name_id = Prob_id;
    case 3
        name_id = CoT_id;
end
acc_enditem = grpstats(TI_resultTable,"IFendItem","mean","DataVars",variable_pool(name_id));
% SybolStats = grpstats(TI_resultTable,"SymDis",{"mean","std","sem"},...
%     "DataVars",["Result35","Result40","ResultLlama3"]);
means = table2array(acc_enditem(:,3:end));
ci = [];
for i=1:4
    % end item trial:row1-end, row-2-no end
    ci(1:2,1:2,i) = [bootci(1000,@(x) mean(x),eval(strcat("TI_resultTable.",...
        variable_pool(i),"(TI_resultTable.IFendItem==0)")))'; ...
        bootci(1000,@(x) mean(x),eval(strcat("TI_resultTable.",...
        variable_pool(i),"(TI_resultTable.IFendItem==1)")))'];
end
ci_lower = squeeze(ci(:,1,:));
ci_upper = squeeze(ci(:,2,:));
error_lower = means - ci_lower;
error_upper = ci_upper - means;
trial_cond = {'without enditem','with enditem'};
numGroups = size(means, 2); % model version
numBars = size(means, 1); % with, without enditem
groupWidth = min(0.5, numBars / (numBars + 1));

figure
hold on

for i = 1:numBars
    % 计算每组条形图的偏移位置
    x = (1:numGroups) - groupWidth/2 + (2*i-1) * groupWidth / (2*numBars);
    bar(x, means(i,:), groupWidth / numBars, 'DisplayName', model_groups{i});
end
for i = 1:numBars
    x = (1:numGroups) - groupWidth/2 + (2*i-1) * groupWidth / (2*numBars);
    errorbar(x, means(i,:), error_lower(i,:), error_upper(i,:), 'k', 'linestyle', 'none', 'CapSize', 5, 'LineWidth', 1.5);
end
% 设置X轴标签
set(gca, 'XTick', 1:numGroups, 'XTickLabel', model_groups);
ylabel('Accuracy');
yline(0.5,'--','LineWidth',0.5,'Color','k')
legend(trial_cond)
ylim([0,1])
title(title_pool(occasion))

end