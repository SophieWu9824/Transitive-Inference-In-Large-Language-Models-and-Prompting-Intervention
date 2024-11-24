function RecalInferPlot(recall,infer,variable_pool,occasion)
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

% plot the accuracy of four language models' recall and inference
% performance with bootstraped 95% confidence inference 
acc_recall = [];
ci_recall = [];
acc_infer = [];
ci_infer = [];
statFun = @(x) mean(x);

for i = 1:4
    recall_dat = eval(strcat("recall.",variable_pool(name_id(i))));
    infer_dat = eval(strcat("infer.",variable_pool(name_id(i))));
    acc_recall(i,1)=mean(recall_dat);
    acc_infer(i,1)=mean(infer_dat);
    ci_recall(i,1:2)=bootci(1000,statFun,recall_dat)';
    ci_infer(i,1:2)=bootci(1000,statFun,infer_dat)';
end
means = [acc_recall';acc_infer'];
ci_lower = [ci_recall(:,1)';ci_infer(:,1)'];
ci_upper = [ci_recall(:,2)';ci_infer(:,2)'];
% 计算误差条的长度
errors_lower = means - ci_lower;
errors_upper = ci_upper - means;

% 定义组标签
model_groups = {'GPT-3.5-Turbo','GPT-4','Llama3-8B','Qwen'};
trial_types = {'recall','inference'};

%plot
figure
hold on

numGroups = size(means, 2);
numBars = size(means, 1);
groupWidth = min(0.8, numBars / (numBars + 1.5));

% 绘制每一组的条形图
for i = 1:numBars
    % 计算每组条形图的偏移位置
    x = (1:numGroups) - groupWidth/2 + (2*i-1) * groupWidth / (2*numBars); 
    bar(x, means(i,:), groupWidth / numBars, 'DisplayName', model_groups{i}); 
end

% 添加误差条
for i = 1:numBars
    x = (1:numGroups) - groupWidth/2 + (2*i-1) * groupWidth / (2*numBars); 
    errorbar(x, means(i,:), errors_lower(i,:), errors_upper(i,:), 'k', 'linestyle', 'none', 'CapSize', 10, 'LineWidth', 1.5);
end

% 设置X轴标签
set(gca, 'XTick', 1:numGroups, 'XTickLabel', model_groups)

% 添加标题和轴标签
% xlabel('Groups');
ylabel('Accuracy');
yline(0.5,'--','LineWidth',0.5,'Color','k')
% 添加图例
legend(trial_types);
title(title_pool(occasion))



end