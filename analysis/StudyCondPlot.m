
function StudyCondPlot(recall,infer,variable_pool,occasion)
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
% plot recall, inference * chain, jump, four models
CondStats_recall = grpstats(recall,"TraOrd","mean",...
    "DataVars",variable_pool(name_id));
CondStats_infer = grpstats(infer,"TraOrd","mean",...
    "DataVars",variable_pool(name_id));
recall_dat = table2array(CondStats_recall(:,3:6));
infer_dat = table2array(CondStats_infer(:,3:6));

% row1:chain, row2: jump,i:model
ci_recall=[];ci_infer=[];
for i=1:4
    ci_recall(1:2,1:2,i) = [bootci(1000,@(x) mean(x),eval(strcat("recall.",variable_pool(name_id(i)),"(recall.TraOrd==0)")))';...
        bootci(1000,@(x) mean(x),eval(strcat("recall.",variable_pool(name_id(i)),"(recall.TraOrd==1)")))'];
    ci_infer(1:2,1:2,i) = [bootci(1000,@(x) mean(x),eval(strcat("infer.",variable_pool(name_id(i)),"(recall.TraOrd==0)")))';...
        bootci(1000,@(x) mean(x),eval(strcat("infer.",variable_pool(name_id(i)),"(recall.TraOrd==1)")))'];
end
model_groups = {'GPT-3.5-Turbo','GPT-4','Llama3-8B','Qwen'};
Study_cond = {'Chain','Jump'};
trial_type = {'recall','inference'};
figure 
for model_i = 1:4
    subplot(1,4,model_i)
    hold on
    means = [recall_dat(:,model_i),infer_dat(:,model_i)];
    ci_lower = [squeeze(ci_recall(:,1,model_i)),squeeze(ci_infer(:,1,model_i))];
    ci_upper = [squeeze(ci_recall(:,2,model_i)),squeeze(ci_infer(:,2,model_i))];
    error_lower = means - ci_lower;
    error_upper = ci_upper - means;
    numGroups = size(means, 2); % recall vs infer
    numBars = size(means, 1); % chain vs jump
    groupWidth = min(0.5, numBars / (numBars + 1));

    % 绘制每一组的条形图
    for i = 1:numBars
        % 计算每组条形图的偏移位置
        x = (1:numGroups) - groupWidth/2 + (2*i-1) * groupWidth / (2*numBars);
        bar(x, means(i,:), groupWidth / numBars, 'DisplayName', trial_type{i});
    end

    % 添加误差条
    for i = 1:numBars
        x = (1:numGroups) - groupWidth/2 + (2*i-1) * groupWidth / (2*numBars);
        errorbar(x, means(i,:), error_lower(i,:), error_upper(i,:), 'k', 'linestyle', 'none', 'CapSize', 5, 'LineWidth', 1.5);
    end
    % 设置X轴标签
    set(gca, 'XTick', 1:numGroups, 'XTickLabel', trial_type);
    % legend(Study_cond);
    title(model_groups(model_i))
    ylabel('Accuracy');
    yline(0.5,'--','LineWidth',0.5,'Color','k')



end




end


